//
//  SwipePageView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-10-20.
//

//
//  SwipePageView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-10-20.
//

import SwiftUI
import FirebaseFirestore

struct SwipePageView: View {
    @State private var profiles: [ProfileCardView.Model] = []
    @State private var isLoading = true

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
            fetchProfiles()
        }
    }

    private func fetchProfiles() {
        let db = Firestore.firestore()
        db.collection("users")
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
