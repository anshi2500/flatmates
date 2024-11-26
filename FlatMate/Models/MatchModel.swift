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
        var matches: [Match] = []
        
        let matchIDs = [
            "XzO97G0ObndYo8fSxchbRLOJJRN2",
            "xDN83AcoU5ZnPEH49gM3EHt4L3V2",
            "J0ZdJ3XQzORZxcSa1COTNq6C1oS2",
            "rNF1Q1CPxad4RNxBFya28YVat3s2"
        ]
        
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

                let match = Match(
                    id: matchID,
                    name: name,
                    imageURL: profilePictureURL
                )
                print("Found match: \(name)")
                matches.append(match)
                dispatchGroup.leave()
            }
        }

        // Call notify after all dispatchGroup tasks are completed
        dispatchGroup.notify(queue: .main) {
            completion(matches)
        }
    }
}
