//
//  MatchModel.swift
//  FlatMate
//
//  Created by Youssef Abdelrhafour on 2024-11-17.
//

import Foundation
import Firebase
import FirebaseAuth

struct Match: Identifiable {
    let id: String
    let name: String
    let imageURL: String
    var chatID: String?
    //let messagePreview: String? // Later iteration
    
    // Get list of userIDs
    
    
    
    
    static func fetchMatches(completion: @escaping ([Match]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user found.")
            completion([]) // Return an empty array if the user is not logged in
            return
        }

        let db = Firestore.firestore()
        let matchesCollection = db.collection("matches")
        let usersCollection = db.collection("users")
        var matchIDs: [String] = []
        var matches: [Match] = []

        let dispatchGroup = DispatchGroup()

        // Query the matches collection to find documents where currentUserID is involved
        matchesCollection
            .whereField("user1", isEqualTo: currentUserID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching matches for user1: \(error)")
                    completion([])
                    return
                }
                
                snapshot?.documents.forEach { document in
                    if let user2 = document.data()["user2"] as? String {
                        matchIDs.append(user2) // Add the other user
                    }
                }
                
                // Query the other way (currentUserID as user2)
                matchesCollection
                    .whereField("user2", isEqualTo: currentUserID)
                    .getDocuments { snapshot, error in
                        if let error = error {
                            print("Error fetching matches for user2: \(error)")
                            completion([])
                            return
                        }
                        
                        snapshot?.documents.forEach { document in
                            if let user1 = document.data()["user1"] as? String {
                                matchIDs.append(user1) // Add the other user
                            }
                        }
                        
                        // Remove duplicates from matchIDs
                        matchIDs = Array(Set(matchIDs))
                        
                        // Fetch user details for each matchID
                        for matchID in matchIDs {
                            dispatchGroup.enter()
                            
                            usersCollection.document(matchID).getDocument(source: .default) { snapshot, error in
                                if let error = error {
                                    print("Error fetching user data: \(error)")
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
                                    print("Found match with chatID: \(name) - \(chatID ?? "No ChatID")")
                                    matches.append(match)
                                    dispatchGroup.leave()
                                }
                            }
                        }
                        
                        // Notify when all user data has been fetched
                        dispatchGroup.notify(queue: .main) {
                            completion(matches)
                        }
                    }
            }
    }

    private static func fetchChatID(user1: String, user2: String, completion: @escaping (String?) -> Void) {
        let db = Firestore.firestore()
        let chatCollection = db.collection("chats")
        
        // Query to check if a chat exists for the given users
        chatCollection
            .whereField("users", arrayContains: user1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching chatID: \(error)")
                    completion(nil)
                    return
                }
                
                if let documents = snapshot?.documents {
                    for document in documents {
                        let data = document.data()
                        if let participants = data["users"] as? [String],
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
            "users": [user1, user2],
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
