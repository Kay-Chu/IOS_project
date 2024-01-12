//
//  ProfileView.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            

                Button{
                    viewModel.signOut()
                } label: {
                    Text("\(user.fullname) Sign Out")
                }
                
            
        } else {
            List {
                Section {
                    Text("user.fullname")
                        .font(.title)
                        .fontWeight(.semibold)
//                        .foregroundStyle(Color:.white)
                }
                Section {
                    
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
