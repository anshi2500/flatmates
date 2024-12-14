//
//  MatchModel.swift
//  FlatMate
//
//  Created by Youssef Abdelrhafour on 2024-11-17.
//

import Firebase
import FirebaseAuth
import Foundation

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
        let matchesQuery = matchesCollection.whereFilter(Filter.orFilter([
            Filter.whereField("user1", isEqualTo: currentUserID),
            Filter.whereField("user2", isEqualTo: currentUserID),
        ]))

        dispatchGroup.enter()
        matchesQuery.getDocuments { snapshot, error in
            defer { dispatchGroup.leave() }

            if let error = error {
                print("Error fetching matches: \(error)")
                return
            }

            print("Query results:")
            for document in snapshot?.documents ?? [] {
                print(document.data())
                let matchData = document.data()
                // If currentUserID is user1, otherUser is user2, else otherUser is user1
                let otherUserID = matchData["user1"] as! String == currentUserID ? matchData["user2"] as! String : matchData["user1"] as! String

                dispatchGroup.enter()
                usersCollection.document(otherUserID).getDocument { userSnapshot, _ in
                    defer { dispatchGroup.leave() }

                    if let userData = userSnapshot?.data(),
                       let name = userData["firstName"] as? String
                    {
                        // Fetch or create chatID
                        ChatUtilities.fetchChatID(user1: currentUserID, user2: otherUserID, completion: { chatID in
                            let imageURL = userData["profileImageURL"] as? String
                            let match = Match(
                                id: matchID,
                                name: name,
                                imageURL: imageURL ?? "",
                                chatID: chatID
                            )
                            
                            matches.append(match)
                            dispatchGroup.leave()
                        })
                    }
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(matches)
        }
    }
}
