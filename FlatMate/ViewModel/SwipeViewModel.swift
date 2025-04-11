//
//  SwipeViewModel.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-25.
//

import FirebaseFirestore
import SwiftUI

class SwipeViewModel: ObservableObject {
    @Published var profiles: [ProfileCardView.Model] = []
    @Published var isLoading: Bool = true
    private let matchService: MatchService
    
    init(matchService: MatchService = MatchService()) {
        self.matchService = matchService
    }
    
    func handleSwipe(userID: String, targetUserID: String, isLike: Bool, completion: @escaping (Bool) -> Void) {
        // Immediately remove the swiped profile locally
        profiles.removeAll { $0.id == targetUserID }
        
        // Update Firestore and handle match
        matchService.swipe(userID: userID, targetUserID: targetUserID, isLike: isLike) { isMatch in
            // Update Firestore to track swiped profile
            let db = Firestore.firestore()
            db.collection("users").document(userID).updateData([
                "swipedProfiles": FieldValue.arrayUnion([targetUserID])
            ]) { error in
                if let error = error {
                    print("Error updating swiped profiles: \(error.localizedDescription)")
                }
                
                // Ensure UI is updated on main thread
                DispatchQueue.main.async {
                    // Double-check removal in case of race conditions
                    self.profiles.removeAll { $0.id == targetUserID }
                    completion(isMatch)
                }
            }
        }
    }
    
    func resetSwipedProfiles(forUser userID: String) async {
        let db = Firestore.firestore()
        do {
            try await db.collection("users")
                .document(userID)
                .updateData(["swipedProfiles": FieldValue.delete()])
            
        } catch {
            print("Error resetting swiped profiles: \(error.localizedDescription)")
        }
    }
    
    func fetchProfiles(currentUserID: String) async {
        let db = Firestore.firestore()
        await MainActor.run { self.isLoading = true }
        
        do {
            //  Fetch the current user doc to grab its 'city' and swiped profiles
            let userDoc = try await db.collection("users").document(currentUserID).getDocument()
            let swipedProfiles = userDoc.data()?["swipedProfiles"] as? [String] ?? []
            
   
            let currentUserCity = userDoc.data()?["city"] as? String ?? ""
            
            // fetch existing matches so we can exclude them
            let matchesSnapshot = try await db.collection("matches").getDocuments()
            let matchedProfiles = matchesSnapshot.documents.compactMap { doc -> String? in
                let data = doc.data()
                if let user1 = data["user1"] as? String,
                   let user2 = data["user2"] as? String {
                    if user1 == currentUserID {
                        return user2
                    } else if user2 == currentUserID {
                        return user1
                    }
                }
                return nil
            }
            
            // Combine both sets of profiles to exclude
            let excludedProfiles = Set(swipedProfiles + matchedProfiles)
            
            //  Fetch other profiles *only* from the same city
            let snapshot = try await db.collection("users")
                .whereField("city", isEqualTo: currentUserCity)
                .whereField("id", isNotEqualTo: currentUserID)
                .getDocuments()
            
            // Decode and filter out excluded profiles
            let profiles = snapshot.documents.compactMap { doc -> ProfileCardView.Model? in
                do {
                    let profile = try doc.data(as: ProfileCardView.Model.self)
                    // Exclude swiped or matched profiles
                    return excludedProfiles.contains(profile.id) ? nil : profile
                } catch {
                    print("Error decoding profile: \(error.localizedDescription)")
                    return nil
                }
            }
            
            await MainActor.run {
                self.profiles = profiles
                self.isLoading = false
            }
        } catch {
            print("Error fetching profiles: \(error.localizedDescription)")
            await MainActor.run { self.isLoading = false }
        }
    }

}
