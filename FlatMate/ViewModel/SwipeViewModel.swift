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

    func fetchProfiles() {
        let db = Firestore.firestore()
        isLoading = true
        db.collection("users")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching profiles: \(error.localizedDescription)")
                    self.isLoading = false
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No profiles found")
                    self.isLoading = false
                    return
                }

                self.profiles = documents.compactMap { doc in
                    do {
                        return try doc.data(as: ProfileCardView.Model.self)
                    } catch {
                        print("Error decoding profile: \(error.localizedDescription)")
                        return nil
                    }
                }
                self.isLoading = false
            }
    }
}
