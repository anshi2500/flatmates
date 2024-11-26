//
//  MatchModel.swift
//  FlatMate
//
//  Created by Youssef Abdelrhafour on 2024-11-17.
//

import Foundation
import Firebase

struct Match: Identifiable {
    let id = UUID()
    let name: String
    let imageURL: String
    //let messagePreview: String? // Later iteration
    
    // Get list of userIDs
    
    
    
    
    static func fetchMatches(completion: @escaping ([Match]) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        var matches: [Match] = []
        
        let matchIDs = [
            "XzO97G0ObndYo8fSxchbRLOJJRN2",
            "xDN83AcoU5ZnPEH49gM3EHt4L3V2"
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
                    name: name,
                    imageURL: profilePictureURL
                )
                matches.append(match)
                dispatchGroup.leave()
            }
            
            dispatchGroup.notify(queue: .main) {
                completion(matches)
            }
        }
    }
}
