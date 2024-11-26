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
    func loadMatches() {
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
                    
                    // Use MessageManager's getOrCreateChatID
                    self?.messageManager.getOrCreateChatID(user1: currentUserID, user2: match.id) { result in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let chatID):
                                matchWithChatID.chatID = chatID
                            case .failure(let error):
                                print("Failed to fetch or create chatID: \(error.localizedDescription)")
                            }
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
}
