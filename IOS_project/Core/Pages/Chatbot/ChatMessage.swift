//
//  ChatMessage.swift
//  IOS_project
//
//  Created by KA YING CHU on 26/1/2024.
//

import SwiftUI

struct ChatMessage: Identifiable {
    var id = UUID().uuidString
    
    var owner: MessageOwner
    var text: String
    
    init(owner: MessageOwner = .user, _ text: String) {
        self.owner = owner
        self.text = text
    }
}
