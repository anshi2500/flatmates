//
//  ChatUtilities.swift
//  FlatMate
//
//  Created by Joey on 2024-11-26.
//

import FirebaseFirestore
import Foundation

struct ChatUtilities {
    static func fetchChatID(user1: String, user2: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let chatCollection = db.collection("chats")
        
        // Query to check if chatID exists
        let chatID = [user1, user2].sorted().joined(separator: "_")
        let chatDocRef = chatCollection.document(chatID)
        
        chatDocRef.getDocument { document, error in
            if let error = error {
                print("Error checking chatID existence: \(error)")
                completion(nil)
                return
            }
            
            if let document = document, document.exists {
                print("Found existing chatID: \(chatID)")
                completion(chatID)
            } else {
                print("ChatID does not exist. Creating a new one.")
                createChatID(user1: user1, user2: user2, completion: completion)
            }
        }
    }
    
    private static func createChatID(user1: String, user2: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let chatCollection = db.collection("chats")
        
        let chatData: [String: Any] = [
            "users": [user1, user2],
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        let chatID = [user1, user2].sorted().joined(separator: "_")
        let chatRef = chatCollection.document(chatID)
        chatRef.setData(chatData) { error in
            if let error = error {
                print("Error creating chatID: \(error)")
                completion(nil)
            } else {
                completion(chatID)
            }
        }
        print("Created new chatID: \(chatID)")
    }
}
