//
//  RegistrationView.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @EnvironmentObject var viewModle: AuthViewModel
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    
    var body: some View {
        
        var formIsValid: Bool {
            return !email.isEmpty
            && email.contains("@")
            && !password.isEmpty
            && password.count > 5
            && confirmPassword == password
            && !fullname.isEmpty
        }
        
        VStack {
            
            // image
            Image("coventry_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
//                .clipShape(Circle())
//                .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                .padding(.vertical, 32)
            
            // form fields
            VStack(alignment: .center,spacing: 4) {
                
                
                
                InputView(text: $fullname, imageName: "person.circle.fill", placeholder: "Full Name")
                
                InputView(text: $email, imageName: "envelope.circle.fill", placeholder: "Name@example.com")
                
                InputView(text: $password, imageName: "key.fill", placeholder: "Password", isSecureField: true)
                
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword, imageName: "key.fill", placeholder: "Confirm you password", isSecureField: true)
                    if !password.isEmpty  {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemGreen))
                        }
                        else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundColor(Color(.systemRed))
                        }
                    }
                }
                
            }
            
            // sign up button
            Button {
                Task {
                    do{
                        try await viewModle.createUser(withEmail: email, password: password, fullname: fullname)
                    } catch {
                        self.alertMessage = error.localizedDescription
                        self.showAlert = true
                    }
                }
            } label: {
                HStack {
                    Text("SIGN UP")
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
                Alert(title: Text("Registration Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            Spacer()
            
            NavigationLink {
                LoginView()
                    .navigationBarBackButtonHidden(true)
            } label: {
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                }
                .font(.custom("Cabal", size: 12))
                .foregroundColor(.mint)
            }
            
            
        }
    }
    
}

#Preview {
    RegistrationView()
}
