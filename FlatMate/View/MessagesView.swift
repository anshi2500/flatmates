//
//  MessagesView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-25.
//

import SwiftUI
import Firebase

struct MessagesView: View {
    @State private var matches: [Match] = []
    @State private var isLoading = true

    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Matches")
                .font(.custom("Outfit-Bold", size: 38))
                .foregroundColor(Color("primary"))
                .padding(.horizontal)
            
            if isLoading {
                // Loading Indicator
                ProgressView("Loading matches...")
                    .padding()
            } else {
                if matches.isEmpty {
                    // Empty State
                    Text("No matches found.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    // List of Matches
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(matches) { match in
                                MatchRow(
                                    name: match.name,
                                    imageURL: match.imageURL
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("Messages")
        .onAppear {
            loadMatches()
        }
    }

    private func loadMatches() {
        Match.fetchMatches { fetchedMatches in
            self.matches = fetchedMatches
            self.isLoading = false
        }
    }
}

#Preview {
    MessagesView()
}
