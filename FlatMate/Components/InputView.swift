//
//  InputView.swift
//  AuthenticationPracticeApp
//
//  Created by 李吉喆 on 2024-10-08.
//

import SwiftUI

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Outfit-ExtraLight", size: 17))
                .padding(.bottom, -5)
            
            if isSecureField {
                SecureField(placeholder, text: $text)
                    .font(.custom("Outfit-ExtraLight", size: 17))
                    .foregroundColor(.black) // This sets the color of the typed text
                    .padding(.all, 12)
                    .background(Color("primaryBackground")) // Using the custom color
                    .cornerRadius(10) // Rounded corners
            } else {
                TextField(placeholder, text: $text)
                    .font(.custom("Outfit-ExtraLight", size: 17))
                    .foregroundColor(.black)
                    .padding(.all, 12)
                    .background(Color("primaryBackground")) // Using the custom color
                    .cornerRadius(10) // Rounded corners
            }
        }
        .frame(maxWidth: .infinity, minHeight: 48) // Adjusted frame
        .padding(.bottom, 20)
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com", isSecureField: false)
    InputView(text: .constant(""), title: "Password", placeholder: "***********", isSecureField: true)
}
