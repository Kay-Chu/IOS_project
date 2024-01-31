//
//  ProfileView.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.
//

import UIKit
import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showingImagePicker = false
    @State private var showingActionSheet = false
    
    @State private var inputImage: UIImage?
    @State private var avatarImage: UIImage?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary //select photo from camera or album
    
    @State private var showShareSheet = false
    @State private var shareItems = [Any]()
    
    var body: some View {

        List {
            Section {
                if let user = viewModel.currentUser {
                    HStack {
                        if let avatarURL = user.avatarURL, let imageURL = URL(string: avatarURL) {
                            AsyncImage(url: imageURL) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .scaledToFill()
                            .frame(width: 72, height: 72)
                            .clipShape(Circle())
                            .onTapGesture {
                                self.showingActionSheet = true
                            }
                        } else {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                                .onTapGesture {
                                    self.showingActionSheet = true
                                }
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .confirmationDialog("Select Image", isPresented: $showingActionSheet, titleVisibility: .visible) {
                        Button("Camera") {
                            self.sourceType = .camera
                            self.showingImagePicker = true
                        }
                        Button("Photo Library") {
                            self.sourceType = .photoLibrary
                            self.showingImagePicker = true
                        }
                        Button("Cancel", role: .cancel) { }
                    }
                    .sheet(isPresented: $showingImagePicker, onDismiss: onDismiss) {
                        ImagePicker(image: self.$inputImage, sourceType: self.sourceType)
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
                                .foregroundColor(.gray)
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
    
    func onDismiss() {
        Task {
            await loadImage()
        }
    }
    
    func loadImage() async {
        guard let inputImage = inputImage else { return }

        do {
            let url = try await viewModel.uploadProfileImage(image: inputImage)
            print("url: \(url)")
            
            avatarImage = inputImage
            
            await viewModel.updateUserAvatarURL(url)
        } catch {
            print("Error uploading profile image: \(error.localizedDescription)")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView().environmentObject(AuthViewModel())
    }
}
