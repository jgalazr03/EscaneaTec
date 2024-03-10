//
//  ChatViewModel.swift
//  ChatGPTApp
//
//  Created by Jesus Alonso Galaz Reyes on 09/03/24.
//

import Foundation

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messages: [Message] = [Message(id: UUID(), role: .system, content: "You are now a Lung Learning Assistant. You will help me understand all aspects of pulmonary science including anatomy, physiology, diseases, treatments, and health practices related to the lungs. Please focus on providing accurate and detailed information about pulmonology at all times", createAt: Date())]

        @Published var currentInput: String = ""
        
        private let openAIService = OpenAIService()

        func sendMessage() {
            let newMessage = Message(id: UUID(), role: .user, content: currentInput, createAt: Date())
            messages.append(newMessage)
            currentInput = ""
            
                            
            Task {
                let response = await openAIService.sendMessage(messages: messages)
                guard let receivedOpenAIMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    return
                }
                let receivedMessage = Message(id: UUID(), role: receivedOpenAIMessage.role, content: receivedOpenAIMessage.content, createAt: Date())
                await MainActor.run {
                    messages.append(receivedMessage)
                }
            }
        }
    }
}

extension Message: Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}


struct Message : Decodable {
    let id : UUID
    let role : SenderRole
    let content : String
    let createAt : Date
}
