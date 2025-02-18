//
//  MessagesView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-25.
//

import SwiftUI
import FirebaseAuth

struct MessagesView: View {
    @StateObject private var viewModel = MessagesViewModel()
    @State private var chatID: String? = nil
    @State private var searchText: String = ""

    let currentUserID = Auth.auth().currentUser?.uid

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // Title
                Text("Matches")
                    .font(.custom("Outfit-Bold", size: 38))
                    .foregroundColor(Color("primary"))
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)

                // Search Bar
                TextField("Search Users", text: $searchText)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    .padding(.horizontal)
                
                if viewModel.isLoading {
                    // Loading Indicator
                    VStack {
                        Spacer()
                        ProgressView("Loading matches...")
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        Spacer()
                    }
                } else {
                    if viewModel.matches.isEmpty {
                        // Empty State
                        Text("No matches found.")
                            .font(.custom("Outfit-Regular", size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .frame(maxHeight: .infinity, alignment: .center)
                    } else {
                        // Filtered List of Matches based on Search Query
                        let filteredMatches = viewModel.matches.filter { match in
                            searchText.isEmpty || match.name.lowercased().contains(searchText.lowercased())
                        }

                        if filteredMatches.isEmpty {
                            Text("No results found.")
                                .font(.custom("Outfit-Regular", size: 20))
                                .foregroundColor(.gray)
                        } else {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(filteredMatches) { match in
                                        NavigationLink(
                                            destination: {
                                                if let chatID = match.chatID {
                                                    MessagingView(
                                                        chatID: chatID,
                                                        currentUserID: viewModel.currentUserID ?? "",
                                                        otherUserID: match.id
                                                    )
                                                } else {
                                                    Text("Chat ID is not available.") // Fallback if chatID isn't ready
                                                }
                                            },
                                            label: {
                                                MatchRow(
                                                    name: match.name,
                                                    imageURL: match.imageURL
                                                )
                                            }
                                        )
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            Spacer()
        }
        .onAppear {
            // Reload matches whenever the view appears
            viewModel.loadMatches()
        }
        .navigationTitle("Messages")
    }
}
