//
//  MessagesView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-25.
//

import SwiftUI

struct MessagesView: View {
    @StateObject private var viewModel = MessagesViewModel()
    @State private var chatID: String? = nil

    var body: some View {
        VStack(alignment: .leading) {
            // Title
            Text("Matches")
                .font(.custom("Outfit-Bold", size: 38))
                .foregroundColor(Color("primary"))
                .padding(.horizontal)

            if viewModel.isLoading {
                // Loading Indicator
                ProgressView("Loading matches...")
                    .padding()
            } else {
                if viewModel.matches.isEmpty {
                    // Empty State
                    Text("No matches found.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    // List of Matches
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.matches) { match in
                                NavigationLink(
                                    destination: {
                                        if let chatID = chatID {
                                            MessagingView(
                                                chatID: chatID,
                                                currentUserID: "ruI196nXC1e06whgCwpBJiwOnNX2",
                                                otherUserID: match.id
                                            )
                                        } else {
                                            ProgressView("Loading chat...")
                                        }
                                    },
                                    label: {
                                        MatchRow(
                                            name: match.name,
                                            imageURL: match.imageURL
                                        )
                                    }
                                )
                                .onAppear {
                                    viewModel.getChatID(user1: "ruI196nXC1e06whgCwpBJiwOnNX2", user2: match.id) { fetchedChatID in
                                        if !fetchedChatID.isEmpty {
                                            self.chatID = fetchedChatID
                                        } else {
                                            // Handle the error case (optional)
                                            print("Failed to fetch chatID for user \(match.id)")
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            Spacer()
        }
        .navigationTitle("Messages")
    }
}

#Preview {
    MessagesView()
}
