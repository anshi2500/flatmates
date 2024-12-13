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
        // Update the match service
        matchService.swipe(userID: userID, targetUserID: targetUserID, isLike: isLike) { isMatch in
            // Step 1: Update Firestore to track swiped profile
            let db = Firestore.firestore()
            db.collection("users").document(userID).updateData([
                "swipedProfiles": FieldValue.arrayUnion([targetUserID])
            ]) { error in
                if let error = error {
                    print("Error updating swiped profiles: \(error.localizedDescription)")
                }
            }

            // Step 2: Call the completion handler
            completion(isMatch)
        }
    }

    func fetchProfiles(currentUserID: String) async {
        let db = Firestore.firestore()
        await MainActor.run { self.isLoading = true } // Update UI on main thread

        do {
            // Step 1: Fetch the user's swiped profiles
            let userDoc = try await db.collection("users").document(currentUserID).getDocument()
            let swipedProfiles = userDoc.data()?["swipedProfiles"] as? [String] ?? []

            // Step 2: Fetch all profiles except the current user
            let snapshot = try await db.collection("users")
                .whereField("id", isNotEqualTo: currentUserID) // Exclude current user
                .getDocuments()

            // Step 3: Decode profiles and filter out swiped profiles locally
            let profiles = snapshot.documents.compactMap { doc -> ProfileCardView.Model? in
                do {
                    let profile = try doc.data(as: ProfileCardView.Model.self)
                    return swipedProfiles.contains(profile.id) ? nil : profile
                } catch {
                    print("Error decoding profile: \(error.localizedDescription)")
                    return nil
                }
            }

            // Step 4: Update UI on main thread
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
