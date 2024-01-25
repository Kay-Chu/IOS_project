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

class AuthViewModel: ObservableObject {
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
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
        }
    }
    
    func createUser(withEmail email:String, password:String, fullname:String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
//            await LoginView()
        } catch {
            
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
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
            
            print("DEBUG: Current user is \(String(describing: self.currentUser))")
        }
        
//        for family in UIFont.familyNames {
//            print("\(family)")
//            for name in UIFont.fontNames(forFamilyName: family) {
//                print("== \(name)")
//            }
//        }
    }
    
}
