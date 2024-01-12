//
//  IOS_projectApp.swift
//  IOS_project
//
//  Created by KA YING CHU on 12/1/2024.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct IOS_projectApp: App {
    
    @StateObject var viewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
