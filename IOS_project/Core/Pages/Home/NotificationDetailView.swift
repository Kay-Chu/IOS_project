//
//  NotificationDetailView.swift
//  IOS_project
//
//  Created by KA YING CHU on 27/1/2024.
//

import SwiftUI

struct NotificationDetailView: View {
    
    let notification: Notification
    @Binding var isPresented: Bool
    
    @State private var showTitle = false
    @State private var showMessage = false
    @State private var showButton = false

    var body: some View {
        VStack {
            HStack {
                if showMessage {
                    Button(action: {
                        withAnimation {
                            self.isPresented = false
                        }
                    }){
                        Image(systemName: "xmark") // Ensure you have a close icon available
                            .foregroundColor(.white)
                    }
                    .opacity(showButton ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5).delay(1.0)) {
                            self.showButton = true
                        }
                    }
                }
            }
            
            Text(notification.title)
                .font(.title)
                .opacity(showTitle ? 1 : 0)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.showTitle = true
                    }
                }
            
            if showTitle {
                Text(notification.message)
                    .font(.body)
                    .opacity(showMessage ? 1 : 0)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5).delay(0.5)) {
                            self.showMessage = true
                        }
                    }
            }
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(
            notification.backgroundImage
                .resizable()
                .scaledToFill()
                .opacity(0.5)
                .overlay(Color.black.opacity(0.3))
                .edgesIgnoringSafeArea(.all) // Apply to all edges, including the top
        )
        .foregroundColor(.white)
        .onDisappear {
            self.showTitle = false
            self.showMessage = false
            self.showButton = false
        }
    }
}
