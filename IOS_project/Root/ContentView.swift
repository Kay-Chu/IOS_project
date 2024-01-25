//
//  ContentView.swift
//  IOS_project
//
//  Created by KA YING CHU on 12/1/2024.
//

import SwiftUI

struct ContentView: View {
    
//    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        VStack {
            
            Group {

                if (viewModel.currentUser != nil && $viewModel.userSession != nil) {
                    TabView {
                        
                        HomePageView().tabItem ({ Image(systemName: "house.fill")
                            Text("Home")
                        }).tag(0)
                        ChatbotView().tabItem ({ Image(systemName: "shareplay")
                            Text("Assistant")
                        }).tag(1)
                        SchoolInfoView().tabItem ({ Image(systemName: "graduationcap.fill")
                            Text("School Info")
                        }).tag(2)
                        ProfileView().tabItem({ Image(systemName: "gearshape.fill")
                            Text("Profile")             }).tag(3)
                        
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
