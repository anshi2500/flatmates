//
//  MessagingView.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

// TODO: Change colours to match UI. Was not sure about colour choice as our theme is pretty dark.

import SwiftUI

struct MessagingView: View {
    // An array that stores temporary messages. Use this array in the future to add to chatUI from database.
    @State private var messageArray: [Message] = [
        Message(id: "1", text: "Hello there!", received: true, timestamp: Date()),
        Message(id: "2", text: "How's it going?", received: false, timestamp: Date()),
        Message(id: "3", text: "Not bad, thanks! And you?", received: true, timestamp: Date())
    ]
    @State private var newMessageText: String = ""

    var body: some View {
        VStack {
            // Title row at the top
            TitleRow()

            // Scrollable messages list
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(messageArray) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.top, 10)
                    .background(Color.white)
                    .cornerRadius(30, corners: [.topLeft, .topRight])
                }
                .background(Color("White"))
                .onChange(of: messageArray) { _ in
                    // Automatically scroll to the bottom when new messages are added
                    if let lastMessage = messageArray.last {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }

            // Message input field
            MessageField(message: $newMessageText, messages: $messageArray, onSend: { text in
                sendMessage(text: text)
            })
        }
        .background(Color("Gray"))
    }

    //TODO: sendMessage should create a new field in firebase
    private func sendMessage(text: String) {
        guard !text.isEmpty else { return }
        // Add the new message to the array
        let newMessage = Message(id: UUID().uuidString, text: text, received: false, timestamp: Date())
        messageArray.append(newMessage)
    }
}

// Preview for MessagingView
#Preview {
    MessagingView()
}
