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
        print("Starting to load matches")
        Match.fetchMatches { [weak self] fetchedMatches in
            DispatchQueue.main.async {
                self?.matches = fetchedMatches
                self?.isLoading = false
                print("Fetched matches: \(fetchedMatches)")
            }
        }
    }
    
    // Function to fetch or create a chatID asynchronously
    func getChatID(user1: String, user2: String, completion: @escaping (String) -> Void) {
        messageManager.getOrCreateChatID(user1: user1, user2: user2) { result in
            switch result {
            case .success(let id):
                print("Successfully fetched chatID: \(id)")
                completion(id)
            case .failure(let error):
                print("Error fetching chatID: \(error.localizedDescription)")
                completion("") // Return empty string on error
            }
        }
    }
}
