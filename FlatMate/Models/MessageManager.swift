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
    func sendMessage(
        chatID: String,
        senderID: String,
        receiverID: String,
        messageText: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        print("sendMessage() called with chatID: \(chatID), senderID: \(senderID), receiverID: \(receiverID), messageText: \(messageText)")
        
        let messageData: [String: Any] = [
            "senderID": senderID,
            "receiverID": receiverID,
            "messageText": messageText,
            "timestamp": FieldValue.serverTimestamp(),
            "read": false,
            "likes": []
        ]
        
        db.collection("chats").document(chatID).collection("messages")
            .addDocument(data: messageData) { error in
                if let error = error {
                    print("Error adding message doc: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Successfully added message doc to chatID: \(chatID). Now creating notification doc...")

                    // 2) Create a notification doc for the receiver
                    NotificationManager.shared.createNotification(
                        receiverID: receiverID,
                        senderID: senderID,
                        message: "New message from \(senderID): \(messageText)",
                        type: "message"
                    ) { notifyError in
                        if let notifyError = notifyError {
                            print("Error creating notification: \(notifyError.localizedDescription)")
                            // We won't fail the entire send if notification fails
                        } else {
                            print("Notification doc created successfully for receiverID: \(receiverID).")
                        }
                    }
                    
                    completion(.success(()))
                }
            }
    }

    // Observes messages in a chat
    func observeMessages(chatID: String, completion: @escaping (Result<[Message], Error>) -> Void) -> ListenerRegistration {
        print("observeMessages() for chatID: \(chatID)")
        
        let query = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .order(by: "timestamp", descending: false)

        return query.addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error in observeMessages snapshotListener: \(error.localizedDescription)")
                completion(.failure(error))
            } else if let documents = snapshot?.documents {
                print("observeMessages received \(documents.count) documents for chatID: \(chatID)")
                
                let messages: [Message] = documents.compactMap { doc in
                    guard
                        let senderID = doc["senderID"] as? String,
                        let receiverID = doc["receiverID"] as? String,
                        let messageText = doc["messageText"] as? String,
                        let timestamp = doc["timestamp"] as? Timestamp,
                        let read = doc["read"] as? Bool,
                        let likes = doc["likes"] as? [String]
                    else {
                        print("Failed to extract message data for document: \(doc.documentID)")
                        return Message(
                            id: doc.documentID,
                            senderID: "",
                            receiverID: "",
                            text: "Error: Missing data",
                            read: false,
                            timestamp: Date(),
                            likes: [],
                            likesCount: 0
                        )
                    }
                    
                    return Message(
                        id: doc.documentID,
                        senderID: senderID,
                        receiverID: receiverID,
                        text: messageText,
                        read: read,
                        timestamp: timestamp.dateValue(),
                        likes: likes,
                        likesCount: likes.count
                    )
                }
                completion(.success(messages))
            }
        }
    }

    // Deletes a message from Firestore
    func deleteMessage(chatID: String, messageID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("deleteMessage() called for chatID: \(chatID), messageID: \(messageID)")
        
        db.collection("chats")
            .document(chatID)
            .collection("messages")
            .document(messageID)
            .delete { error in
                if let error = error {
                    print("Error deleting message: \(error.localizedDescription)")
                    completion(.failure(error))
                } else {
                    print("Successfully deleted message doc \(messageID) from chatID: \(chatID)")
                    completion(.success(()))
                }
            }
    }
    
    // Toggle Like: Adds/removes a like for a message
    func toggleLike(chatID: String, messageID: String, userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        print("toggleLike() called for chatID: \(chatID), messageID: \(messageID), userID: \(userID)")
        
        let messageRef = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .document(messageID)
        
        messageRef.getDocument { document, error in
            if let error = error {
                print("Error getting doc in toggleLike: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let document = document, document.exists {
                var messageData = document.data() ?? [:]
                var likes = messageData["likes"] as? [String] ?? []

                if let userIndex = likes.firstIndex(of: userID) {
                    print("User \(userID) found in likes array, removing them.")
                    likes.remove(at: userIndex)
                } else {
                    print("User \(userID) not found in likes, adding them.")
                    likes.append(userID)
                }
                
                messageData["likes"] = likes
                messageRef.updateData(messageData) { error in
                    if let error = error {
                        print("Error updating likes array: \(error.localizedDescription)")
                        completion(.failure(error))
                    } else {
                        print("Successfully toggled like for userID: \(userID)")
                        completion(.success(()))
                    }
                }
            } else {
                print("toggleLike doc not found or doesn't exist.")
            }
        }
    }

    // Function to count likes for a message
    func getLikeCount(for messageID: String, chatID: String, completion: @escaping (Result<Int, Error>) -> Void) {
        print("getLikeCount() called for messageID: \(messageID), chatID: \(chatID)")
        
        let messageRef = db.collection("chats")
            .document(chatID)
            .collection("messages")
            .document(messageID)

        messageRef.getDocument { document, error in
            if let error = error {
                print("Error in getLikeCount: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }

            if let document = document, document.exists {
                let likes = document["likes"] as? [String] ?? []
                print("getLikeCount found \(likes.count) likes for messageID: \(messageID)")
                completion(.success(likes.count))
            } else {
                print("getLikeCount doc not found for messageID: \(messageID)")
                completion(.success(0)) // or .failure(...) if you prefer
            }
        }
    }
}

