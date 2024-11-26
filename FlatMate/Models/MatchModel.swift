//
//  MatchModel.swift
//  FlatMate
//
//  Created by Youssef Abdelrhafour on 2024-11-17.
//

import Foundation
import Firebase

struct Match: Identifiable {
    let id: String
    let name: String
    let imageURL: String
    var chatID: String?
    //let messagePreview: String? // Later iteration
    
    // Get list of userIDs
    
    
    
    
    static func fetchMatches(completion: @escaping ([Match]) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        let chatCollection = db.collection("chats")
        var matches: [Match] = []
        
        let matchIDs = [
            "XzO97G0ObndYo8fSxchbRLOJJRN2",
            "xDN83AcoU5ZnPEH49gM3EHt4L3V2",
            "J0ZdJ3XQzORZxcSa1COTNq6C1oS2",
            "rNF1Q1CPxad4RNxBFya28YVat3s2"
        ]
        
        let currentUserID = "ruI196nXC1e06whgCwpBJiwOnNX2" // Replace with dynamically fetched userID
        let dispatchGroup = DispatchGroup()
        
        for matchID in matchIDs {
            dispatchGroup.enter()
            
            usersCollection.document(matchID).getDocument(source: .default) { snapshot, error in
                if let error = error {
                    print("Error fetching match data: \(error)")
                    dispatchGroup.leave()
                    return
                }
                
                guard let data = snapshot?.data(),
                      let name = data["firstName"] as? String,
                      let profilePictureURL = data["profileImageURL"] as? String else {
                    print("Data missing or in incorrect format for matchID: \(matchID)")
                    dispatchGroup.leave()
                    return
                }
                
                // Fetch or create chatID
                fetchChatID(user1: currentUserID, user2: matchID) { chatID in
                    let match = Match(
                        id: matchID,
                        name: name,
                        imageURL: profilePictureURL,
                        chatID: chatID
                    )
                    print("Found match with chatID: \(name) - \(chatID)")
                    matches.append(match)
                    dispatchGroup.leave()
                }
            }
        }
        
        // Call notify after all dispatchGroup tasks are completed
        dispatchGroup.notify(queue: .main) {
            completion(matches)
        }
    }

    private static func fetchChatID(user1: String, user2: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let chatCollection = db.collection("chats")
        
        // Query to check if a chat exists for the given users
        chatCollection
            .whereField("participants", arrayContains: user1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching chatID: \(error)")
                    completion(nil)
                    return
                }
                
                if let documents = snapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        if let participants = data["participants"] as? [String],
                           participants.contains(user2) {
                            print("Found existing chatID for \(user1) and \(user2)")
                            completion(document.documentID)
                            return
                        }
                    }
                }
                
                // If no existing chat, create a new one
                createChatID(user1: user1, user2: user2, completion: completion)
            }
    }

    private static func createChatID(user1: String, user2: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let chatCollection = db.collection("chats")
        
        let chatData: [String: Any] = [
            "participants": [user1, user2],
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        var ref: DocumentReference? = nil
        ref = chatCollection.addDocument(data: chatData) { error in
            if let error = error {
                print("Error creating chatID: \(error)")
                completion(nil)
                return
            }
            
            if let documentID = ref?.documentID {
                print("Created new chatID: \(documentID)")
                completion(documentID)
            }
        }
    }
}
