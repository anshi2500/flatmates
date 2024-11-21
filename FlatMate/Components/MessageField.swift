//
//  MessageField.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import SwiftUI

struct MessageField: View {
    @Binding var message: String
    @Binding var messages: [Message]
    var onSend: (String) -> Void // Passes the message text to the parent view
    
    var body: some View {
        HStack {
            CustomTextField(placeholder: Text("Enter your message here"), text: $message)
            Button {
                if !message.isEmpty {
                    onSend(message) // Notify parent view to handle the message sending logic
                    message = "" // Clear the text field
                }
            } label: {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color("chatPrimary"))
                    .cornerRadius(50)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(Color("chatSecondary"))
        .cornerRadius(50)
        .padding()
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> () = {_ in}
    var commit: () -> () = {}
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                placeholder
                    .opacity(0.5)
            }
            
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

