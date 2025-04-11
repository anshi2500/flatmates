//
//  MessageViewModel.swift
//  FlatMate
//
//  Created by Joey on 2024-11-20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MessagingViewModel: ObservableObject {
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
    
    func deleteMessage(chatID: String, messageID: String, senderID: String) {
        guard senderID == Auth.auth().currentUser?.uid else {
            errorMessage = "You can only delete your own messages."
            return
        }
        
        messageManager.deleteMessage(chatID: chatID, messageID: messageID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Message deleted successfully.")
                case .failure(let error):
                    self?.errorMessage = "Error deleting message: \(error.localizedDescription)"
                }
            }
        }
    }

    // Toggle Like: Adds/removes a like for a message
    func toggleLike(chatID: String, messageID: String, userID: String) {
        messageManager.toggleLike(chatID: chatID, messageID: messageID, userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Like toggled successfully")
                    
                    self?.loadMessages(for: chatID)
                case .failure(let error):
                    self?.errorMessage = "Error toggling like: \(error.localizedDescription)"
                }
            }
        }
    }

    // Function to fetch the like count for a specific message
    func getLikeCount(chatID: String, messageID: String) {
        messageManager.getLikeCount(for: messageID, chatID: chatID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let likeCount):
                    // Update the like count for the message
                    if let index = self?.messages.firstIndex(where: { $0.id == messageID }) {
                        self?.messages[index].likesCount = likeCount
                    }
                case .failure(let error):
                    self?.errorMessage = "Error fetching like count: \(error.localizedDescription)"
                }
            }
        }
    }
}
