//
//  AuthViewModel.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SwiftUI


class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    enum UploadError: Error {
        case userNotLoggedIn
        case invalidImageData
    }
    
    init(){
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email:String, password:String) async throws {
        
        do {
            print(userSession?.uid ?? "no uid")
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func createUser(withEmail email:String, password:String, fullname:String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(uid: result.user.uid, username: fullname, email: email, avatarURL:"")
            let encodedUser = try Firestore.Encoder().encode(user)
            
            // Here, use `user.id` to reference the document id, which now contains the uid string
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func uploadProfileImage(image: UIImage) async throws -> URL {
        guard let uid = userSession?.uid else {
            throw UploadError.userNotLoggedIn
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            throw UploadError.invalidImageData
        }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let storageRef = Storage.storage().reference()
        let ref = Storage.storage().reference(withPath: "\(uid).jpg")

        ref.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading profile image: \(error.localizedDescription)")
                return
            }
        }
        
        do {
            let _ = try await ref.putDataAsync(imageData, metadata: metadata)
            
            let downloadURL = try await ref.downloadURL()
            
            try await Firestore.firestore().collection("users").document(uid).setData(["avatarURL": downloadURL.absoluteString], merge: true)
            
            DispatchQueue.main.async { [weak self] in
                self?.currentUser?.avatarURL = downloadURL.absoluteString
            }
            
            return downloadURL
        } catch let error as NSError {
            print("Error code: \(error.code)")
            print("Error description: \(error.localizedDescription)")
            print("Error user info: \(error.userInfo)")
            throw error
        }
    }
    
    func updateUserAvatarURL(_ url: URL) async {
        guard let uid = userSession?.uid else { return }

        let usersRef = Firestore.firestore().collection("users").document(uid)
        do {
            try await usersRef.updateData(["avatarURL": url.absoluteString])
            DispatchQueue.main.async {
                self.currentUser?.avatarURL = url.absoluteString
            }
            print("User's avatar URL successfully updated.")
        } catch {
            print("Error updating user's avatar URL: \(error.localizedDescription)")
        }
    }

   
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: Failed to sign out with error  \(error.localizedDescription)")
        }
    }

    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let snapshot =  try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        
        DispatchQueue.main.async {
            self.currentUser = try? snapshot.data(as: User.self)
            
        }
        
    }
    
    func saveFeelingToFirebase(feeling: Feeling) async throws {
        
        guard let uid = userSession?.uid else { return }
        let userRef = Firestore.firestore().collection("users").document(uid)

        let feelingData: [String: Any] = [
            "id": feeling.id,
            "title": feeling.title,
            "content": feeling.content,
            "timestamp": Timestamp(date: feeling.timestamp)
        ]

        do {
            _ = try await userRef.collection("feelings").addDocument(data: feelingData)
            print("Feeling saved successfully")
        } catch {
            print("Error saving feeling: \(error)")
            throw error
        }
    }
    
}
