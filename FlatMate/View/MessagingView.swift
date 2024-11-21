//
//  MessagingView.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

// TODO: Change colours to match UI. Was not sure about colour choice as our theme is pretty dark.

import SwiftUI

//TODO Remove below and make it generic
let receiver = "0"
let sender = "1"

struct MessagingView: View {
    // An array that stores temporary messages. Use this array in the future to add to chatUI from database.
    @State private var messageArray: [Message] = []
        /*Message(id: "1", text: "Hello there!", received: true, timestamp: Date()),
        Message(id: "2", text: "How's it going?", received: false, timestamp: Date()),
        Message(id: "3", text: "Not bad, thanks! And you?", received: true, timestamp: Date())
    ]*/
    @State private var newMessageText: String = ""
    
    let messageManager = MessageManager()

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
                messageManager.sendMessage(
                    chatID: "ExampleID",
                    senderID: "ExampleSender",
                    receiverID: "ExampleReceiver",
                    messageText: text
                ) { result in
                    switch result {
                    case .success:
                        print("Message sent successfully")
                    case .failure:
                        print("Error sending message")
                    }
                }
            })
        }
        .background(Color("Gray"))
    }
    
}

// Preview for MessagingView
#Preview {
    MessagingView()
}
