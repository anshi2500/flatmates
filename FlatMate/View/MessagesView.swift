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
    @State private var searchText: String = ""
    
    // Access your NotificationViewModel from the environment
    @EnvironmentObject var notificationVM: NotificationViewModel
    
    let currentUserID = Auth.auth().currentUser?.uid
    
    // Filter matches by search text
    var filteredMatches: [Match] {
        viewModel.matches.filter { match in
            searchText.isEmpty || match.name.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                // Large custom title
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
                        if filteredMatches.isEmpty {
                            Text("No results found.")
                                .font(.custom("Outfit-Regular", size: 20))
                                .foregroundColor(.gray)
                        } else {
                            ScrollView {
                                VStack(spacing: 16) {
                                    ForEach(filteredMatches) { match in
                                        // For each match, figure out how many unread from that user
                                        let unreadCount = unreadCountFor(match.id)
                                        
                                        NavigationLink(
                                            destination: destinationView(for: match),
                                            label: {
                                                HStack {
                                                    // Show the match row with the user’s info
                                                    MatchRow(name: match.name, imageURL: match.imageURL)
                                                    
                                                    Spacer()
                                                    
                                                    // If unreadCount > 0, show a blue dot + number
                                                    if unreadCount > 0 {
                                                        HStack(spacing: 6) {
                                                            Circle()
                                                                .fill(Color.blue)
                                                                .frame(width: 8, height: 8)
                                                            Text("\(unreadCount)")
                                                                .foregroundColor(.black)
                                                        }
                                                        .padding(.trailing, 4)
                                                    }
                                                }
                                            }
                                        )
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
                print("MessagesView onAppear -> loadMatches()")
                viewModel.loadMatches()
            }
            // hiding the default navigation bar
            .navigationBarHidden(true)
        }
    }
    
    // Helper function to compute how many unread notifications exist
    private func unreadCountFor(_ senderId: String) -> Int {
        guard let me = currentUserID else { return 0 }
        return notificationVM.notifications.filter {
            $0.senderId == senderId &&
            $0.receiverId == me &&
            !$0.isRead
        }.count
    }
    
    // Helper function returning the destination view for a given match.
    @ViewBuilder
    private func destinationView(for match: Match) -> some View {
        if let chatID = match.chatID {
            let _ = print("Navigating to chatID: \(chatID) with otherUserID: \(match.id)")
            MessagingView(
                chatID: chatID,
                currentUserID: viewModel.currentUserID ?? "",
                otherUserID: match.id
            )
        } else {
            Text("Chat ID is not available.")
        }
    }
}
