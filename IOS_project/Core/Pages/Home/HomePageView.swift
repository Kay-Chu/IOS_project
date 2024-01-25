//
//  HomePageView.swift
//  IOS_project
//
//  Created by KA YING CHU on 27/1/2024.
//

import SwiftUI

struct HomePageView: View {
    
    @State private var notifications: [Notification] = [
        Notification(title: "School Notice 1⃣️", message: "School will be closed tomorrow due to weather conditions.", backgroundImageName: "Notification1"),
            Notification(title: "School Notice 2⃣️",message: "Parent-teacher meetings are scheduled for next week.", backgroundImageName: "Notification2"),
            Notification(title: "School Notice 3⃣️",message: "New library hours have been updated on the website.", backgroundImageName: "Notification3")
        ]
    
    @State private var showingNotificationDetail = false
    @State private var selectedNotification: Notification?
    
    @State private var buttonScale: CGFloat = 1.0
    
    var body: some View {
        NavigationView {
        
            VStack {
                
                Section{
                    
                    Text("Lastest Notices")
                        .font(.custom("Cabal-Bold", size: 20))
                        .padding(.top, 50)
                        .padding(.horizontal, 30)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TabView {
                        ForEach(notifications) { notification in
                            Button(action: {
                                self.selectedNotification = notification
                                self.showingNotificationDetail = true
                            }) {
                                Text(notification.title)
                                    .font(.custom("Cabal", size: 15))
                                    .foregroundColor(.black)
                                    .frame(width: 350, height: 220)
                                    .background(notification.backgroundImage
                                        .resizable()
                                        .scaledToFill()
                                        .opacity(0.3))
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                                    .padding()
                            }
                            
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .sheet(isPresented: $showingNotificationDetail) {
                        if let selectedNotification = selectedNotification {
                            NotificationDetailView(notification: selectedNotification, isPresented: $showingNotificationDetail)
                        } else {
                            NotificationDetailView(notification: notifications.first ?? Notification(title:"Default message", message: "", backgroundImageName: ""), isPresented: $showingNotificationDetail)
                        }
                    }
                }
                
                Divider()
               
                Section{
                    
                        HStack(spacing: 20) {
                            NavigationLink(destination: ChatbotView()) {
                                VStack{
                                    Image(systemName:"shareplay").foregroundColor(.white)
                                    Text("My Chat")
                                    
                                }.frame(width: 100, height: 100)
                                    .background(Color.mint)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                
                            }
                            NavigationLink(destination: SchoolInfoView()) {
                                Text("My Test")
                                    .frame(width: 100, height: 100)
                                    .background(Color.mint)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            
                            NavigationLink(destination: ProfileView()) {
                                Text("My Mood")
                                    .frame(width: 100, height: 100)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                
                
                Divider()
                
                Section {
                    ForEach(notifications) { notification in
                        
                        NotificationRowView(imageName: notification.backgroundImageName, title: notification.title, description: notification.message)
                            .frame(height: 100)
                    }
                }.padding(.horizontal,30)
                
            }
        }
    }
}

#Preview {
    HomePageView()
}
