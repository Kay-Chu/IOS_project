//
//  Notification.swift
//  IOS_project
//
//  Created by KA YING CHU on 27/1/2024.
//

import SwiftUI

struct Notification: Identifiable {
    
    let id = UUID()
    let title: String
    let message: String
    let backgroundImageName: String
    
    var backgroundImage: Image {
        Image(backgroundImageName, bundle: .main)
    }
}
