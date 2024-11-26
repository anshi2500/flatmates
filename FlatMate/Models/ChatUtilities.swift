//
//  ChatUtilities.swift
//  FlatMate
//
//  Created by Joey on 2024-11-26.
//

import FirebaseFirestore
import Foundation

struct ChatUtilities {
    static func getOrCreateChatID(
        user1: String,
        user2: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let db = Firestore.firestore()
        let chatCollection = db.collection("chats")
        
        // Query to check if a chat already exists for the given users
        chatCollection
            .whereField("participants", arrayContains: user1)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // Look for a matching document
                if let documents = snapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        if let participants = data["participants"] as? [String], participants.contains(user2) {
                            completion(.success(document.documentID)) // Found existing chatID
                            return
                        }
                    }
                }
                
                // No chat found, create a new one
                createChatID(user1: user1, user2: user2, completion: completion)
            }
    }
    
    private static func createChatID(
        user1: String,
        user2: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        let db = Firestore.firestore()
        let chatCollection = db.collection("chats")
        
        let chatData: [String: Any] = [
            "participants": [user1, user2],
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        chatCollection.addDocument(data: chatData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                let documentID = chatCollection.document().documentID
                completion(.success(documentID)) // Return the new chatID
            }
        }
    }
}
