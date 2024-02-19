//
//  ChatbotView.swift
//  IOS_project
//
//  Created by KA YING CHU on 26/1/2024.
//

import SwiftUI

struct ChatbotView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel: ChatbotViewModel
    
    
    @State private var showDocumentPicker = false
    @State private var pickedURL: URL?
    
    
    init() {
            let context = PersistenceController.shared.container.viewContext
            _viewModel = StateObject(wrappedValue: ChatbotViewModel(context: context))
        }
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.chatMessages) { message in
                            messageView(message)
                        }
                        
                        Color.clear
                            .frame(height: 1)
                            .id("bottom")
                    }
                }
                
                .onReceive(viewModel.$chatMessages.throttle(for: 0.5, scheduler: RunLoop.main, latest: true)) { chatMessages in
                    guard !chatMessages.isEmpty else {return}
                    withAnimation {
                        proxy.scrollTo("bottom")
                    }
                }
                
            }
            
            Button("Upload File") {
                showDocumentPicker = true
            }
            
            if let pickedURL = pickedURL {
                Text("Picked file: \(pickedURL.lastPathComponent)")
                // You can add additional logic to upload the audio file here.
            }
            
            HStack {
                Button ("Clear"){
                    deleteHistoryMessage()
                }
                TextField("Message...", text: $viewModel.message, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                if viewModel.isWaitingForResponse {
                    ProgressView()
                        .padding()
                } else {
                    Button("Send") {
                        sendMessage()
                    }
                    .buttonStyle(BounceButtonStyle())
                }
            }
            .padding()
        }
        
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                pickedURL = url
            }
        }
        
        
    }
    
    func messageView(_ message: ChatMessage) -> some View {
        HStack {
            
            if message.owner == .user {
                Spacer(minLength: 60)
            }
            
            if !message.text.isEmpty {
                VStack {
                    Text(message.text)
                        .foregroundStyle(message.owner == .user ? .white : .black)
                        .padding(12)
                        .background(message.owner == .user ? .mint : .gray.opacity(0.1))
                        .cornerRadius(16)
                        .overlay(alignment: message.owner == .user ? .topTrailing : .topLeading) {
                            Text(message.owner.rawValue.capitalized)
                                .foregroundStyle(.gray)
                                .font(.caption)
                                .offset(y: -16)
                        }
                }
            }
            
            if message.owner == .assistant {
                Spacer(minLength: 60)
            }
        }
    }
    
    
    func sendMessage() {
        Task {
            do {
                try await viewModel.sendMessage()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteHistoryMessage() {
        viewModel.deleteHistoryMessage()
    }
}

#Preview {
    ChatbotView()
}
