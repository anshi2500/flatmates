//
//  MessagingView.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import SwiftUI
import FirebaseAuth

struct MessagingView: View {
    @StateObject var viewModel: MessagingViewModel
    var chatID: String
    var currentUserID: String
    var otherUserID: String

    @State private var newMessageText: String = ""

    init(chatID: String, currentUserID: String, otherUserID: String) {
        self.chatID = chatID
        self.currentUserID = currentUserID
        self.otherUserID = otherUserID
        _viewModel = StateObject(wrappedValue: MessagingViewModel())
    }

    var body: some View {
        VStack {
            // Title row at the top
            TitleRow(userID: otherUserID)

            // Scrollable messages list
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.messages, id: \.id) { message in
                            HStack {
                                MessageBubble(message: message, received: currentUserID != message.senderID)
                                
                                // Delete button for the current user's messages
                                if message.senderID == currentUserID {
                                    Button(action: {
                                        viewModel.deleteMessage(chatID: chatID, messageID: message.id, senderID: message.senderID)
                                    }) {
                                        Image(systemName: "trash.fill")
                                            .foregroundColor(.red)
                                            .padding(8)
                                            .background(Color.white)
                                            .cornerRadius(20)
                                    }
                                    .padding(.trailing, 5)
                                }
                                
                                // Like button
                                Button(action: {
                                    viewModel.toggleLike(chatID: chatID, messageID: message.id, userID: currentUserID)
                                }) {
                                    HStack {
                                        Image(systemName: "hand.thumbsup.fill")
                                            .foregroundColor(message.likes.contains(currentUserID) ? .blue : .gray)
                                        Text("\(message.likes.count)")
                                            .font(.subheadline)
                                    }
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                }
                                .padding(.trailing, 5)
                            }
                        }
                    }
                    .onChange(of: viewModel.messages) { _ in
                        if let lastMessage = viewModel.messages.last {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                    .padding(.top, 10)
                    .background(Color.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                }
                .background(Color.white)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            
            // Message input field
            MessageField(message: $newMessageText) { text in
                viewModel.sendMessage(
                    chatID: chatID,
                    senderID: currentUserID,
                    receiverID: otherUserID,
                    messageText: text
                )
            }
        }
        .background(Color.white)
        .onAppear {
            print("MessagingView onAppear -> loadMessages(for: \(chatID))")
            viewModel.loadMessages(for: chatID)
            
            // Mark notifications from 'otherUserID' as read,
            // so that only notifications from other senders remain.
            if let loggedInUser = Auth.auth().currentUser?.uid, loggedInUser == currentUserID {
                print("MessagingView -> Marking notifications from senderID: \(otherUserID) as read for receiverID: \(currentUserID)")
                NotificationManager.shared.markAllNotificationsAsRead(
                    senderID: otherUserID,
                    receiverID: currentUserID
                ) { error in
                    if let error = error {
                        print("Error marking notifications as read: \(error.localizedDescription)")
                    } else {
                        print("Successfully marked notifications from \(otherUserID) as read.")
                    }
                }
            }
        }
    }
}

struct MessagingView_Previews: PreviewProvider {
    static var previews: some View {
        MessagingView(chatID: "dummyChatID", currentUserID: "dummyCurrentUser", otherUserID: "dummyOtherUser")
    }
}
