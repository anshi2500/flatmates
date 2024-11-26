//
//  MessagesViewModel.swift
//  FlatMate
//
//  Created by Joey on 2024-11-25.
//

import Foundation
import FirebaseAuth

class MessagesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading: Bool = false
    @Published var currentUserID: String? // Store the current user ID
    
    private let messageManager = MessageManager()
    
    init() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user found during initialization.")
            self.currentUserID = nil
            return
        }
        self.currentUserID = uid
        loadMatches()
    }
    
    // Fetches matches and updates state
    private func loadMatches() {
        guard let currentUserID = self.currentUserID else {
            print("Error: currentUserID is nil")
            isLoading = false
            return
        }
        
        isLoading = true
        
        Match.fetchMatches { [weak self] fetchedMatches in
            DispatchQueue.global().async {
                let updatedMatches = fetchedMatches.map { match -> Match in
                    var matchWithChatID = match
                    self?.getChatID(user1: currentUserID, user2: match.id) { chatID in
                        DispatchQueue.main.async {
                            matchWithChatID.chatID = chatID
                        }
                    }
                    return matchWithChatID
                }

                DispatchQueue.main.async {
                    self?.matches = updatedMatches
                    self?.isLoading = false
                }
            }
        }
    }
    
    // Function to fetch or create a chatID asynchronously
    func getChatID(user1: String, user2: String, completion: @escaping (String) -> Void) {
           // Your logic for fetching or creating a chatID
           DispatchQueue.global().async {
               let chatID = "\(user1)_\(user2)" // Replace this with actual logic
               DispatchQueue.main.async {
                   completion(chatID)
               }
           }
       }
}
