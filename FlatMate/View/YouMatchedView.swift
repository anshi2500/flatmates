//
//  YouMatchedView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-11-26.
//

import SwiftUI

@ViewBuilder
func renderProfileImageFromUrl(_ profileUrl: String?) -> some View {
    if let profileImageURL = profileUrl, let url = URL(string: profileImageURL) {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
                .frame(width: 150, height: 150)
        }
    } else {
        // Default placeholder for users without a profile image
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .foregroundColor(.gray)
            .clipShape(Circle())
    }
}

// Helper function to calculate age from date of birth
// Copied from EditProfileView, we should probably make a utilities file
private func calculateAge(from dob: Date) -> Int {
    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
    return ageComponents.year ?? 0
}

struct YouMatchedView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @Binding var isOpen: Bool
    var thisUser: User
    var otherUser: ProfileCardView.Model

    @State private var chatID: String? = nil
    @State private var isChatLoading: Bool = false
    @State private var navigateToMessagingView = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("It's a Match!")
                    .font(.custom("Outfit-Bold", size: 48))
                    .foregroundStyle(Color("primary"))
                    .padding()
                Spacer()
                HStack {
                    VStack {
                        renderProfileImageFromUrl(otherUser.profileImageURL)
                        Text("\(otherUser.firstName), \(otherUser.age)")
                            .font(.custom("Outfit-Bold", size: 24))
                    }
                    .padding()
                    VStack {
                        renderProfileImageFromUrl(thisUser.profileImageURL)
                        Text("\(thisUser.firstName ?? "You"), \(calculateAge(from: thisUser.dob!))")
                            .font(.custom("Outfit-Bold", size: 24))
                    }
                    .padding()
                }
                Spacer()
                HStack(spacing: 30) {
                    ButtonView(
                        title: "Keep Swiping",
                        action: {
                            isOpen = false
                        },
                        type: .outline
                    )
                    ButtonView(
                        title: "Send Message",
                        action: {
                            if let chatID = chatID {
                                print("Navigating to chatID: \(chatID)")
                                navigateToMessagingView = true
                            } else {
                                print("ChatID not yet loaded.")
                            }
                        }
                    )
                    .disabled(chatID == nil || isChatLoading)
                }
            }
            .padding()
            .onAppear {
                fetchChatID() // Fetch chatID on appear
            }
            .navigationDestination(isPresented: $navigateToMessagingView) {
                if let chatID = chatID {
                    MessagingView(
                        chatID: chatID,
                        currentUserID: thisUser.id,
                        otherUserID: otherUser.id
                    )
                } else {
                    Text("Loading chat...")
                }
            }
        }
    }

    private func fetchChatID() {
        guard chatID == nil else { return } // Prevent duplicate calls
        isChatLoading = true

        ChatUtilities.getOrCreateChatID(user1: thisUser.id, user2: otherUser.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedChatID):
                    self.chatID = fetchedChatID
                case .failure(let error):
                    print("Error fetching or creating chatID: \(error.localizedDescription)")
                }
                self.isChatLoading = false
            }
        }
    }
}
