//
//  MessageManager.swift
//  FlatMate
//
//  Created by Joey on 2024-11-20.
//

import Foundation
import FirebaseFirestore

private let db = Firestore.firestore()

class MessageManager{
    
    func sendMessage(chatID: String, senderID:String, receiverID: String, messageText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Organize message data to be sent
        let messageData: [String: Any] = [
            "senderID": senderID,
            "receiverID": receiverID,
            "messageText": messageText,
            "timestamp": FieldValue.serverTimestamp(), // Automatically set the timestamp
            "isRead": false] // Mark the message as unread
        
        // Add message to chat's collection
        db.collection("chats").document(chatID).collection("messages")
            .addDocument(data: messageData) {
                error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
}
