//
//  ProfileView.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showShareSheet = false
    @State private var shareItems = [Any]()
    
    var body: some View {

        List {
            Section {
                if let user = viewModel.currentUser {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading,spacing: 4){
                            Text(user.fullname)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                    
                }else {
                    HStack {
                        Text("user.fullname")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                    
                        VStack(alignment: .leading,spacing: 4){
                            Text("user.fullname")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text("user.fullname")
                                .font(.footnote)
                                .accentColor(.gray)
                        }
                    }
                }
            }
            Section("General") {
                HStack{
                    Button(action: {
                        shareItems = [URL(string: "http://coventry.ac.uk/") ?? ""]
                        showShareSheet = true
                    }) {
                        RowView(imageName: "square.and.arrow.up", title: "Share with friends", tintColor: Color(.systemMint))
                    }
                    Spacer()
                }
                .sheet(isPresented: $showShareSheet, content: {
                            ActivityView(activityItems: shareItems)
                        })
                HStack{
                    RowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                    Spacer()
                    Text("1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
            }
            Section("Account") {
                Button {
                    viewModel.signOut()
                } label: {
                    RowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: .mint)
                }
            }
        }
   

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel())
    }
}
