//
//  MessagesViewModel.swift
//  FlatMate
//
//  Created by Joey on 2024-11-25.
//

import Foundation

class MessagesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading: Bool = false
    
    private let messageManager = MessageManager()
    
    init() {
        loadMatches()
    }
    
    // Fetches matches and updates state
    private func loadMatches() {
           isLoading = true
           Match.fetchMatches { [weak self] fetchedMatches in
               DispatchQueue.global().async {
                   let updatedMatches = fetchedMatches.map { match -> Match in
                       var matchWithChatID = match
                       self?.getChatID(user1: "ruI196nXC1e06whgCwpBJiwOnNX2", user2: match.id) { chatID in
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
