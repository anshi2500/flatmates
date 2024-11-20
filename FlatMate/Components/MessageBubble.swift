//
//  MessageBubble.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import SwiftUI

struct MessageBubble: View {
    var message: Message
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: message.received ? .leading :
                .trailing) {
                    HStack {
                        Text(message.text)
                            .padding()
                            .background(message.received ? Color("chatSecondary") : Color("chatPrimary"))
                            .cornerRadius(30)
                    }
                    .frame(maxWidth: 300, alignment: message.received ? .leading : .trailing)
                    .onTapGesture {
                        showTime.toggle()
                    }
                    
                    if showTime {
                        Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(message.received ? .leading : .trailing, 25)
                    }
                }
                .frame(maxWidth: .infinity, alignment:
                        message.received ? .leading : .trailing)
                .padding(message.received ? .leading : .trailing)
                .padding(.horizontal, 10)
    }
}

#Preview {
    MessageBubble(message: Message(id: "12345", text: "I don't know what to type! But you're really stupid today you mother fucker!", received: true, timestamp: Date()))
}
