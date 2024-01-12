//
//  ContentView.swift
//  IOS_project
//
//  Created by KA YING CHU on 12/1/2024.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        VStack {
            
            Group {
//                LoginView()
                if (viewModel.currentUser != nil || viewModel.userSession != nil) {
                    TabView {
                        
                        QuestionsView().tabItem ({ Image(systemName: "questionmark.app.fill")
                            Text("Test")
                        }).tag(0)
                        SchoolInfoView().tabItem ({ Image(systemName: "graduationcap.fill")
                            Text("School Info")
                        }).tag(1)
                        ProfileView().tabItem({ Image(systemName: "gearshape.fill")
                            Text("Profile")             }).tag(2)
                        
                    }
                } else {
                    LoginView()
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
