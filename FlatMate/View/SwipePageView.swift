//
//  SwipePageView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-10-20.
//

import SwiftUI
import FirebaseFirestore

struct SwipePageView: View {
    @EnvironmentObject var viewModel: AuthViewModel // Injected AuthViewModel
    @State private var profiles: [ProfileCardView.Model] = []
    @State private var isLoading = true
    @State private var currentUserID: String = "" // Initialize as an empty string

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading Profiles...")
            } else if profiles.isEmpty {
                Text("No profiles available.")
            } else {
                let model = SwipeCardsView.Model(cards: profiles)
                SwipeCardsView(model: model) { model in
                    print(model.swipedCards)
                    model.reset()
                }
            }
        }
        .onAppear {
            // Set the current user ID from the viewModel and fetch profiles
            if let userID = viewModel.currentUser?.id {
                currentUserID = userID
                fetchProfiles()
            } else {
                print("Error: Unable to get the current user ID")
                isLoading = false
            }
        }
    }

    private func fetchProfiles() {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("id", isNotEqualTo: currentUserID) // Exclude the current user
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching profiles: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else {
                    print("No profiles found")
                    return
                }

                print("Profiles found: \(documents.count)")

                profiles = documents.compactMap { doc in
                    do {
                        return try doc.data(as: ProfileCardView.Model.self)
                    } catch {
                        print("Error decoding document \(doc.documentID): \(error)")
                        return nil
                    }
                }

                isLoading = false
                print("Loaded profiles: \(profiles)")
            }
    }
}
