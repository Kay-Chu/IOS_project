//
//  User.swift
//  IOS_project
//
//  Created by KA YING CHU on 13/1/2024.
//

import Foundation

struct User: Identifiable, Codable {
    
    var id: String
    
    let uid: String
    let fullname: String
    let email: String
    var avatarURL: String?
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname){
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
    
    init(uid: String, username: String, email: String, avatarURL: String? = nil) {
        self.id = uid  
        self.uid = uid
        self.fullname = username
        self.email = email
        self.avatarURL = avatarURL
    }
}

extension User {
    static var MOCK_USER = User(uid: NSUUID().uuidString, username: "Kobe Bryant", email: "test@gmail.com", avatarURL: "")
}
