//
//  MessageBubble.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import SwiftUI


struct MessageBubble: View {
    var message: Message
    var received: Bool
    @State private var showTime = false
    
    var body: some View {
        VStack(alignment: received ? .leading :
                .trailing) {
                    HStack {
                        Text(message.text)
                            .padding()
                            .background(received ? Color("primaryBackground") : Color("primary"))
                            .foregroundStyle(received ? Color(.black) : Color(.white))
                            .cornerRadius(30)
                    }
                    .frame(maxWidth: 300, alignment: received ? .leading : .trailing)
                    .onTapGesture {
                        showTime.toggle()
                    }
                    
                    if showTime {
                        Text("\(message.timestamp.formatted(.dateTime.hour().minute()))")
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(received ? .leading : .trailing, 25)
                    }
                }
                .frame(maxWidth: .infinity, alignment:
                        received ? .leading : .trailing)
                .padding(received ? .leading : .trailing)
                .padding(.horizontal, 10)
    }
}

#Preview {
}
