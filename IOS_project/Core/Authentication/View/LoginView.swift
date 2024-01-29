//
//  LoginView.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.
//

import SwiftUI
import Foundation

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // image
                Image("coventry_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                    .padding(.vertical, 32)
                
                // form fields
                InputView(text: $email, imageName: "envelope.circle", placeholder: "Enter your email")
                InputView(text: $password, imageName: "key", placeholder: "Enter your password", isSecureField: true)
                
                
                // sign in button
                Button {
                    Task {
                        do {
                                try await viewModel.signIn(withEmail: email, password: password)
                            } catch {
                                self.alertMessage = error.localizedDescription
                                self.showAlert = true
                            }
                    }
                } label: {
                    HStack {
                        Text("SIGN IN")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .disabled(!formIsValid)
                    .opacity(formIsValid ? 1.0 : 0.5)
                    .frame(width: 280, height: 38)
                }
                .buttonStyle(BounceButtonStyle())
                .padding()
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Login Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
                    
                // sign up button
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    }
                    .font(.custom("Cabal", size: 12))
                    .foregroundColor(.mint)
                }
                
                
            }
        }
    }
}

//#Preview {
//    LoginView()
//}
