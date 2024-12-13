//
//  InputView.swift
//  AuthenticationPracticeApp
//
//  Created by 李吉喆 on 2024-10-08.
//

import SwiftUI

enum FieldToFocus {
    case textField, secureField
}

struct InputFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Outfit-ExtraLight", size: 17))
            .frame(minHeight: 28)
            .foregroundColor(.black)
            .padding(.all, 12)
            .background(Color("primaryBackground"))
            .cornerRadius(10)
    }
}

struct InputView: View {
    @Binding var text: String
    let title: String
    let placeholder: String
    var isSecureField: Bool
    @FocusState var focusedField: FieldToFocus?

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.custom("Outfit-ExtraLight", size: 17))
                .padding(.bottom, -5)

            // Ternary operator to decide between SecureField and TextField
            Group {
                if isSecureField {
                    SecureField(placeholder, text: $text).focused($focusedField, equals: .secureField)
                } else {
                    TextField(placeholder, text: $text).focused($focusedField, equals: .textField)
                }
            }
            .autocorrectionDisabled(true)
            .autocapitalization(.none)
            .modifier(InputFieldStyle())
        }
        .frame(maxWidth: .infinity) // Adjusted frame
        .onChange(of: focusedField) { focusedField = isSecureField ? .textField : .secureField }
    }
}

#Preview {
    InputView(text: .constant(""), title: "Email Address", placeholder: "name@example.com", isSecureField: false)
    InputView(text: .constant(""), title: "Password", placeholder: "***********", isSecureField: true)
}
