//
//  MessagingView.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

// TODO: Change colours to match UI. Was not sure about colour choice as our theme is pretty dark.

import SwiftUI
struct MessagingView: View {
    @StateObject var viewModel = MessageViewModel() // Observes the MessageViewModel for changes
    var chatID: String
    var senderID: String
    var receiverID: String
 
   
    @State private var newMessageText: String = ""

    var body: some View {
        VStack {
            // Title row at the top
            TitleRow()

            // Scrollable messages list
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(viewModel.messages, id: \.id) { message in
                            MessageBubble(message: message)
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
                .background(Color(.white))
                
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
                    senderID: senderID,
                    receiverID: receiverID,
                    messageText: text
                )
            }
        }
        .background(Color("Gray"))
    }
}

// Preview for MessagingView
#Preview {
    MessagingView(chatID: "testChatID", senderID: "testSenderID", receiverID: "testReceiverID")
}
