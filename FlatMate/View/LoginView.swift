//
//  LoginView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 103)
                .padding(.bottom, 20)
            Text("Welcome Back")
                .font(.custom("Outfit-Bold", size: 28))
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
            VStack {
                InputView(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                InputView(text: $password, title: "Password", placeholder: "***************", isSecureField: true)
                ButtonView(title: "Log In", action: {})
            }
            .padding(.horizontal, 20)
            Spacer()
            HStack {
                Text("Don't have an account?")
                    .font(.custom("Outfit-Regular", size: 17))
                    .foregroundColor(.primary)
                
                NavigationLink(destination: SignupView().navigationBarBackButtonHidden(true)) { // Navigates to the signup view
                    Text("Register")
                        .font(.custom("Outfit-Bold", size: 17))
                        .foregroundColor(Color("primary")) // Use your custom primary color here
                        .underline()
                }
            }
            .padding(.bottom, 20)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    LoginView()
}
