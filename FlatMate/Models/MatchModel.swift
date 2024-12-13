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
    
    static func fetchMatches(completion: @escaping ([Match]) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user found.")
            completion([])
            return
        }

        let db = Firestore.firestore()
        let matchesCollection = db.collection("matches")
        let usersCollection = db.collection("users")
        
        let dispatchGroup = DispatchGroup()
        var matches: [Match] = []
        
        // Query for matches where user is either user1 or user2
        let query1 = matchesCollection.whereField("user1", isEqualTo: currentUserID)
        let query2 = matchesCollection.whereField("user2", isEqualTo: currentUserID)
        
        dispatchGroup.enter()
        query1.getDocuments { snapshot, error in
            defer { dispatchGroup.leave() }
            
            if let error = error {
                print("Error fetching matches as user1: \(error)")
                return
            }
            
            for document in snapshot?.documents ?? [] {
                if let user2 = document.data()["user2"] as? String {
                    dispatchGroup.enter()
                    usersCollection.document(user2).getDocument { userSnapshot, userError in
                        defer { dispatchGroup.leave() }
                        
                        if let userData = userSnapshot?.data(),
                           let name = userData["firstName"] as? String,
                           let imageURL = userData["profileImageURL"] as? String {
                            let match = Match(id: user2, name: name, imageURL: imageURL)
                            matches.append(match)
                        }
                    }
                }
            }
        }
        
        dispatchGroup.enter()
        query2.getDocuments { snapshot, error in
            defer { dispatchGroup.leave() }
            
            if let error = error {
                print("Error fetching matches as user2: \(error)")
                return
            }
            
            for document in snapshot?.documents ?? [] {
                if let user1 = document.data()["user1"] as? String {
                    dispatchGroup.enter()
                    usersCollection.document(user1).getDocument { userSnapshot, userError in
                        defer { dispatchGroup.leave() }
                        
                        if let userData = userSnapshot?.data(),
                           let name = userData["firstName"] as? String,
                           let imageURL = userData["profileImageURL"] as? String {
                            let match = Match(id: user1, name: name, imageURL: imageURL)
                            matches.append(match)
                        }
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            completion(matches)
        }
    }
}
