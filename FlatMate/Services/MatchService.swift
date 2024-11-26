//
//  MatchService.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-25.
//

import FirebaseFirestore

class MatchService {
    private let db = Firestore.firestore()

    // MARK: - Swipe Function
    func swipe(userID: String, targetUserID: String, isLike: Bool, completion: @escaping (Bool) -> Void) {
        print("Swipe function called for userID: \(userID), targetUserID: \(targetUserID), isLike: \(isLike)")
        let swipeData: [String: Any] = [
            "swiper": userID,
            "swiped": targetUserID,
            "swipeType": isLike ? "like" : "dislike",
            "createdAt": Timestamp()
        ]
        
        db.collection("swipes").addDocument(data: swipeData) { error in
            if let error = error {
                print("Error saving swipe: \(error.localizedDescription)")
                completion(false)
                return
            }

            if isLike {
                self.checkForMatch(userID: userID, targetUserID: targetUserID, completion: completion)
            } else {
                completion(false) // No match for dislikes
            }
        }
    }

    // MARK: - Check for Match
    private func checkForMatch(userID: String, targetUserID: String, completion: @escaping (Bool) -> Void) {
        db.collection("swipes")
            .whereField("swiper", isEqualTo: targetUserID)
            .whereField("swiped", isEqualTo: userID)
            .whereField("swipeType", isEqualTo: "like")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking for match: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                if let documents = snapshot?.documents, !documents.isEmpty {
                    self.createMatch(user1: userID, user2: targetUserID, completion: completion)
                } else {
                    completion(false)
                }
            }
    }

    // MARK: - Create Match
    private func createMatch(user1: String, user2: String, completion: @escaping (Bool) -> Void) {
        let matchData: [String: Any] = [
            "user1": user1 < user2 ? user1 : user2,
            "user2": user1 < user2 ? user2 : user1,
            "matchedAt": Timestamp(),
            "isActive": true
        ]
        
        db.collection("matches").addDocument(data: matchData) { error in
            if let error = error {
                print("Error creating match: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Match created between \(user1) and \(user2)")
                completion(true)
            }
        }
    }
}
