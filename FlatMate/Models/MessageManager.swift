//
//  MessageManager.swift
//  FlatMate
//
//  Created by Joey on 2024-11-20.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

private let db = Firestore.firestore()

class MessageManager: ObservableObject {

    // Adds a message to the database
    func sendMessage(chatID: String, senderID: String, receiverID: String, messageText: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let messageData: [String: Any] = [
            "senderID": senderID,
            "receiverID": receiverID,
            "messageText": messageText,
            "timestamp": FieldValue.serverTimestamp(), // Automatically set the timestamp
            "read": false, // Mark the message as unread
            "likes": [] // Initialize the likes as an empty array
        ]
        
        db.collection("chats").document(chatID).collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }

    // Observes messages in a chat
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
                    // Extract the necessary fields from the document
                    guard
                        let senderID = doc["senderID"] as? String,
                        let receiverID = doc["receiverID"] as? String,
                        let messageText = doc["messageText"] as? String,
                        let timestamp = doc["timestamp"] as? Timestamp,
                        let read = doc["read"] as? Bool,
                        let likes = doc["likes"] as? [String] // Fetch the likes array
                    else {
                        // If any data is missing, print an error and return a default message
                        print("Failed to extract message data for document: \(doc.documentID)")
                        return Message(
                            id: doc.documentID,
                            senderID: "",
                            receiverID: "",
                            text: "Error: Missing data",
                            read: false,
                            timestamp: Date(),
                            likes: [],
                            likesCount: 0 // Set likesCount to 0 for default
                        )
                    }

                    // Successfully extracted all data, now return a valid Message object
                    return Message(
                        id: doc.documentID,
                        senderID: senderID,
                        receiverID: receiverID,
                        text: messageText,
                        read: read,
                        timestamp: timestamp.dateValue(),
                        likes: likes,
                        likesCount: likes.count // Pass the count of likes
                    )
                }
                completion(.success(messages))
            }
        }
    }

    
    // Deletes a message from Firestore
    func deleteMessage(chatID: String, messageID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        db.collection("chats")
            .document(chatID)
            .collection("messages")
            .document(messageID)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
    
    // Toggle Like: Adds/removes a like for a message
    func toggleLike(chatID: String, messageID: String, userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let messageRef = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .document(messageID)
        
        messageRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let document = document, document.exists {
                var messageData = document.data() ?? [:]
                var likes = messageData["likes"] as? [String] ?? []

                if let userIndex = likes.firstIndex(of: userID) {
                    // User is already in the likes array, so we remove them (dislike)
                    likes.remove(at: userIndex)
                } else {
                    // Add user to the likes array (like)
                    likes.append(userID)
                }
                
                messageData["likes"] = likes
                messageRef.updateData(messageData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }

    // Function to count likes for a message
    func getLikeCount(for messageID: String, chatID: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let messageRef = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .document(messageID)

        messageRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let document = document, document.exists {
                let likes = document["likes"] as? [String] ?? []
                completion(.success(likes.count))
            }
        }
    }
}
