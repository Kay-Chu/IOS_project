//
//  NotificationRowView.swift
//  IOS_project
//
//  Created by KA YING CHU on 28/1/2024.
//

import SwiftUI

struct NotificationRowView: View {
    
    let imageName: String
    let title: String
    let description: String
    
    
    var body: some View {
        HStack(spacing: 12) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    NotificationRowView(imageName: "Notification1", title: "Notification1", description: "This is for Notification1.")
}
