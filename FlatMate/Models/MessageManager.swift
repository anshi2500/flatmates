//
//  MessageManager.swift
//  FlatMate
//
//  Created by Joey on 2024-11-20.
//

import Foundation
import FirebaseFirestore

private let db = Firestore.firestore()

class MessageManager: ObservableObject {
    
    // Adds a message to the database
    func sendMessage(chatID: String, senderID:String, receiverID: String, messageText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        // Organize message data to be sent
        let messageData: [String: Any] = [
            "senderID": senderID,
            "receiverID": receiverID,
            "messageText": messageText,
            "timestamp": FieldValue.serverTimestamp(), // Automatically set the timestamp
            "read": false] // Mark the message as unread
        
        // Add message to chat's collection
        db.collection("chats").document(chatID).collection("messages")
            .addDocument(data: messageData) {
                error in
                if let error = error {
                    completion(.failure(error))
                    print("Message error")
                } else {
                    completion(.success(()))
                }
            }
    }
    
    // Gets all messages between two users and returns in sorted array
    func getMessages(chatID: String, completion: @escaping (Result<[Message], Error>) -> Void) {
        // Query messages for the specified chat ID
        let query = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .order(by: "timestamp", descending: false)

        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error)) // Handle Firestore errors
            } else if let documents = snapshot?.documents {
                // Safely map documents to Message objects
                let messages: [Message] = documents.compactMap { doc in
                    guard
                        let senderID = doc["senderID"] as? String,
                        let receiverID = doc["receiverID"] as? String,
                        let messageText = doc["messageText"] as? String,
                        let timestamp = doc["timestamp"] as? Timestamp,
                        let read = doc["read"] as? Bool
                    else {
                        print("Invalid document encountered: \(doc.documentID)")
                        // Return a default placeholder message for invalid data
                        return Message(
                            id: doc.documentID,
                            senderID: "Unknown",
                            receiverID: "Unknown",
                            text: "Invalid message data",
                            read: false,
                            timestamp: Date.distantPast // Current date as a fallback
                        )
                    }

                    // Create and return a valid Message object
                    return Message(
                        id: doc.documentID,
                        senderID: senderID,
                        receiverID: receiverID,
                        text: messageText,
                        read: read,
                        timestamp: timestamp.dateValue()
                        
                    )
                }

                // Return the array of messages through the completion handler
                completion(.success(messages))
            } else {
                completion(.success([])) // No messages found, return empty array
            }
        }
    }
    func observeMessages(chatID: String, completion: @escaping (Result<[Message], Error>) -> Void) -> ListenerRegistration {
        let query = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .order(by: "timestamp", descending: false)

        return query.addSnapshotListener { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents {
                let messages: [Message] = documents.compactMap { doc in
                    guard
                        let senderID = doc["senderID"] as? String,
                        let receiverID = doc["receiverID"] as? String,
                        let messageText = doc["messageText"] as? String,
                        let timestamp = doc["timestamp"] as? Timestamp,
                        let read = doc["read"] as? Bool
                    else { return nil }

                    return Message(
                        id: doc.documentID,
                        senderID: senderID,
                        receiverID: receiverID,
                        text: messageText,
                        read: read,
                        timestamp: timestamp.dateValue()
                    )
                }
                completion(.success(messages))
            }
        }
    }
    
    func getOrCreateChatID(user1: String, user2: String, completion: @escaping (Result<String, Error>) -> Void) {
        let userIDs = [user1, user2].sorted()
        let query = db.collection("chats").whereField("users", isEqualTo: userIDs)
        
        query.getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
            } else if let documents = snapshot?.documents, !documents.isEmpty {
                if let document = documents.first {
                    completion(.success(document.documentID))
                }
            } else {
                let chatData: [String: Any] = [
                    "users": userIDs,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                let newChatRef = db.collection("chats").document()
                
                newChatRef.setData(chatData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        newChatRef.getDocument { _, docError in
                            if let docError = docError {
                                completion(.failure(docError))
                            } else {
                                completion(.success(newChatRef.documentID))
                            }
                        }
                    }
                }
            }
        }
    }
    
}
