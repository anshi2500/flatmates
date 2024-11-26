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
        matchService.swipe(userID: userID, targetUserID: targetUserID, isLike: isLike, completion: completion)
    }

    func fetchProfiles(currentUserID: String) async {
        let db = Firestore.firestore()
        await MainActor.run { self.isLoading = true } // Update UI on main thread

        do {
            // Firestore query to fetch all users except the current user
            let snapshot = try await db.collection("users")
                .whereField("id", isNotEqualTo: currentUserID)
                .getDocuments()

            // Decode profiles into the model
            let profiles = snapshot.documents.compactMap { doc -> ProfileCardView.Model? in
                do {
                    return try doc.data(as: ProfileCardView.Model.self)
                } catch {
                    print("Error decoding profile: \(error.localizedDescription)")
                    return nil
                }
            }

            // Update UI on main thread
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
