//
//  MessageField.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import SwiftUI

struct MessageField: View {
   @Binding var message: String
   var onSend: (String) -> Void // Notify parent to handle sending logic
   @State private var showEmojiPicker = false // To toggle the emoji picker visibility

   var body: some View {
       VStack {
           HStack {
               CustomTextField(placeholder: Text("Enter your message here"), text: $message)
               
               // Emoji button (smiling face)
               Button(action: {
                   withAnimation {  // Apply animation for toggling the emoji picker
                       showEmojiPicker.toggle()  // Toggle the emoji picker visibility
                   }
               }) {
                   Image(systemName: "face.smiling")
                       .font(.system(size: 24)) // Icon size of 24 points
                       .foregroundColor(Color(.white)) // Set color to dark gray
               }
               .padding(10)
               .background(Color("primary"))
               .cornerRadius(50)
               
               // Paper plane button
               Button {
                   if !message.isEmpty {
                       onSend(message) // Send the message to the parent view
                       message = "" // Clear the text field after sending
                   }
               } label: {
                   Image(systemName: "paperplane.fill")
                       .foregroundColor(.white)
                       .padding(10)
                       .background(Color("primary"))
                       .cornerRadius(50)
               }
           }
           .padding(.horizontal)
           .padding(.vertical, 10)
           .background(Color("primaryBackground"))
           .cornerRadius(50)
           .padding()
           
           // Emoji picker view (shown when showEmojiPicker is true)
           if showEmojiPicker {
               emojiPicker
                   .transition(.move(edge: .bottom)) // Animation for emoji picker
           }
       }
   }

   // Emoji Picker View
   private var emojiPicker: some View {
       let emojis: [String] = [
           "😀", "😂", "😍", "😎", "😢", "😡", "🥳", "🤔", "🤗", "🤩", "🙄", "😳", "😇", "😉", "😋", "😜", "🤪",
           "🥰", "😱", "😴", "🤤", "😭", "😅", "🤓", "😞", "😩", "😤",
           "🐶", "🐱", "🐭", "🐰", "🦊", "🐻", "🐼", "🐸", "🐷", "🐵", "🐦", "🐧", "🦉", "🐳", "🦄", "🐝", "🐢", "🐬", "🐙",
           "🍎", "🍌", "🍓", "🍉", "🍒", "🍔", "🍕", "🍩", "🍿", "🍪", "🌮", "🥗", "🍣", "🍱", "🥤", "☕", "🍇", "🥪", "🥞",
           "⚽", "🏀", "🏈", "🎾", "🏓", "🥋", "🎤", "🎮", "🎹", "🎨", "🧵", "🎬", "🎧", "🎯", "🎷", "🎻", "🏆", "🎟️", "🎲",
           "🚗", "✈️", "🚀", "🚂", "🚤", "🛳️", "🏠", "🏔️", "🗽", "🏝️", "🏙️", "🏨", "⛺", "🗿",
           "❤️", "💔", "🔥", "⭐", "🌈", "☀️", "⚡", "❄️", "💧", "🌍", "✨", "🎉", "🛑", "✔️", "➕", "➖", "♻️", "🔔", "🔒", "🔑",
           "🇺🇸", "🇬🇧", "🇨🇦", "🇮🇳", "🇦🇺", "🇫🇷", "🇩🇪", "🇯🇵", "🇧🇷", "🇰🇷", "🇨🇳", "🇮🇹"
       ]
       
       return VStack {
           ScrollView {
               LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 5), spacing: 10) {
                   ForEach(emojis, id: \.self) { emoji in
                       Button(action: {
                           // Append selected emoji to message
                           message += emoji
                           // Close the emoji picker after selection
                           showEmojiPicker = false
                       }) {
                           Text(emoji)
                               .font(.largeTitle) // Large font for emojis
                       }
                       .buttonStyle(PlainButtonStyle()) // To avoid any default button styling
                   }
               }
               .padding() // Padding around the grid
           }
           .frame(maxHeight: 300) // Limit the height of the emoji picker
           .background(Color("primaryBackground")) // Background for the picker
           .cornerRadius(15) // Rounded corners
           .padding(.horizontal)
       }
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
