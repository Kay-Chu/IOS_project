//
//  ChatbotViewModel.swift
//  IOS_project
//
//  Created by KA YING CHU on 26/1/2024.
//

import SwiftUI
import ChatGPTSwift
import CoreData

@MainActor

class ChatbotViewModel: ObservableObject {
    
    @Published var chatMessages: [ChatMessage] = []
    @Published var message: String = ""
    @Published var isWaitingForResponse: Bool = false
    
    private var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        loadMessages()
    }
    
    func loadMessages() {
        
        
        
        let request: NSFetchRequest<Messages> = Messages.fetchRequest()
        do {
            let messagesEntities = try context.fetch(request)
            let chatMessages = messagesEntities.map { entity -> ChatMessage in
                let ownerRawValue = entity.owner ?? ""
                let ownerValue = MessageOwner(rawValue: ownerRawValue) ?? .user
                let messageText = entity.text ?? ""
                
                return ChatMessage(owner: ownerValue, messageText)
                
            }
            // Assign the resulting array to your chatMessages property
            self.chatMessages = chatMessages
        } catch {
            print("Could not load messages: \(error.localizedDescription)")
        }
    }
    func addNewMessage(_ newMessage: ChatMessage) {
        let messagesEntity = Messages(context: context)
        messagesEntity.owner = newMessage.owner.rawValue
        messagesEntity.text = newMessage.text

        do {
            try context.save()
//            chatMessages.append(newMessage)
        } catch {
            print("Error saving new message: \(error)")
        }
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }

    
    let api = ChatGPTAPI(apiKey: APIKeys.openAPIKey)
    

    func sendMessage() async throws {
        
        let userMessage = ChatMessage(message)
        chatMessages.append(userMessage)
        isWaitingForResponse = true
        
        addNewMessage(userMessage)
        
        let assistantRole = try await api.sendMessage(text: message, model: "gpt-4", systemText: "You are a Mental Health Assistant in Coventry University. You can help students come over their problems.")
        let assistantMessage = ChatMessage(owner: .assistant, assistantRole)
        chatMessages.append(assistantMessage)
        
//        let stream = try await api.sendMessageStream(text: message)
//        message = ""
        
//        let response = try await api.sendMessage(text: message, model: "gpt-4")
//       
//        let newMessage = ChatMessage(owner: .assistant, response)
        chatMessages[chatMessages.count - 1]  = assistantMessage
        
//        for try await line in stream {
//            
//            
//            
//            if let lastMessage = chatMessages.last {
//                let text = lastMessage.text
//                
//                print("response:\(response)")
//                
//                let newMessage = ChatMessage(owner: .assistant, text + line)
//                chatMessages[chatMessages.count - 1]  = newMessage
//            }
//        }
        
        if let lastMessage = chatMessages.last, lastMessage.owner == .assistant {
                let completeAssistantMessage = ChatMessage(owner: .assistant, lastMessage.text)
                addNewMessage(completeAssistantMessage)
        }
        
        isWaitingForResponse = false
        message = ""
                
    }
    

    
    
}
