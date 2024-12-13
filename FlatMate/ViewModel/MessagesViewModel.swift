import Foundation
import FirebaseAuth
import FirebaseFirestore

class MessagesViewModel: ObservableObject {
    @Published var matches: [Match] = []
    @Published var isLoading: Bool = false
    @Published var currentUserID: String?
    private let chatUtilities = ChatUtilities()
    
    init() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("Error: No authenticated user found during initialization.")
            self.currentUserID = nil
            return
        }
        self.currentUserID = uid
        loadMatches()
    }
    
    func loadMatches() {
        guard let currentUserID = self.currentUserID else {
            print("Error: currentUserID is nil")
            isLoading = false
            return
        }
        
        isLoading = true
        
        Match.fetchMatches { [weak self] fetchedMatches in
            guard let self = self else { return }
            
            DispatchQueue.global().async {
                let dispatchGroup = DispatchGroup()
                var updatedMatches = fetchedMatches
                
                // Process each match to get/create chat IDs
                for (index, match) in fetchedMatches.enumerated() {
                    dispatchGroup.enter()
                    
                    ChatUtilities.getOrCreateChatID(user1: currentUserID, user2: match.id) { result in
                        switch result {
                        case .success(let chatID):
                            updatedMatches[index] = Match(
                                id: match.id,
                                name: match.name,
                                imageURL: match.imageURL,
                                chatID: chatID
                            )
                        case .failure(let error):
                            print("Error getting/creating chatID: \(error.localizedDescription)")
                        }
                        dispatchGroup.leave()
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self.matches = updatedMatches
                    self.isLoading = false
                }
            }
        }
    }
}

// Extension to help with async operations
extension DispatchQueue {
    static func asyncOnMain(_ block: @escaping () -> Void) {
        if Thread.isMainThread {
            block()
        } else {
            DispatchQueue.main.async(execute: block)
        }
    }
}
