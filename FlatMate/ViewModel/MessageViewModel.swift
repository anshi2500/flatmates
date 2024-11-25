//
//  MessageViewModel.swift
//  FlatMate
//
//  Created by Joey on 2024-11-20.
//

import Foundation
import FirebaseFirestore

class MessageViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var errorMessage: String? // For error handling

    private let messageManager = MessageManager()
    private var listener: ListenerRegistration?

    func loadMessages(for chatID: String) {
        // Real-time updates
        listener = messageManager.observeMessages(chatID: chatID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let messages):
                    self?.messages = messages
                case .failure(let error):
                    self?.errorMessage = "Error fetching messages: \(error.localizedDescription)"
                }
            }
        }
    }

    func stopObservingMessages() {
        listener?.remove()
    }

    func sendMessage(chatID: String, senderID: String, receiverID: String, messageText: String) {
            messageManager.sendMessage(chatID: chatID, senderID: senderID, receiverID: receiverID, messageText: messageText) { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        print("Message sent successfully")
                    case .failure(let error):
                        self?.errorMessage = "Error sending message: \(error.localizedDescription)"
                    }
                }
            }
        }
}
