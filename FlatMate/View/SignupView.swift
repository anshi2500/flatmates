//
//  SignupView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI
import FirebaseAuth

struct SignupView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?
    @State private var showPasswordRules = false
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Logo Image
                    Image("Logo Straight Blue")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 103)
                        .padding(.top, 15)
                        .padding(.bottom, 18)
                        .padding(.horizontal, 35)
                    
                    // Signup Title
                    Text("Create Your Account")
                        .font(.custom("Outfit-Bold", size: 28))
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 22)
                    
                    // Input Fields
                    VStack {
                        InputView(text: $username, title: "Username", placeholder: "username", isSecureField: false)
                        InputView(text: $email, title: "Email Address", placeholder: "name@example.com", isSecureField: false)
                        
                        // Password Field with Tooltip
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Password")
                                    .font(.system(size: 16, weight: .light))
                                
                                Button(action: {
                                    showPasswordRules.toggle()
                                }) {
                                    Image(systemName: "questionmark.circle")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 5)
                                }
                                .popover(isPresented: $showPasswordRules) {
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        Text("Password Requirements")
                                            .font(.headline)
                                            .padding(.bottom, 5)
                                        
                                        // Use a scrollable VStack if content exceeds height
                                        ScrollView {
                                            VStack(alignment: .leading, spacing: 8) {
                                                Text("• Password must be at least 12 characters long.")
                                                Text("• Password must include at least one uppercase letter.")
                                                Text("• Password must include at least one lowercase letter.")
                                                Text("• Password must include at least one number.")
                                                Text("• Password must include at least one special character.")
                                            }
                                            .padding(.horizontal, 15) // Add some horizontal padding to the text
                                        }
                                        .frame(height: 250)
                                    }
                                    .padding()
                                    .presentationCompactAdaptation(.popover)
                                }
                            }
                            
                            // Password input with visibility toggle on right side
                            ZStack {
                                if isPasswordVisible {
                                    TextField("Password", text: $password)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(5)
                                } else {
                                    SecureField("***************", text: $password)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(5)
                                }
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                        
                        // Confirm Password input with visibility toggle on right side
                        VStack (alignment: .leading) {
                            HStack {
                                Text("Confirm Password")
                                    .font(.system(size: 16, weight: .light))
                            }
                            
                            ZStack {
                                if isConfirmPasswordVisible {
                                    TextField("Confirm Password", text: $confirmPassword)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(5)
                                } else {
                                    SecureField("***************", text: $confirmPassword)
                                        .padding(10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(5)
                                }
                                
                                HStack {
                                    Spacer()
                                    Button(action: {
                                        isConfirmPasswordVisible.toggle()
                                    }) {
                                        Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.trailing, 10)
                                }
                            }
                        }
                        
                        // Error Message Display
                        ZStack {
                            Text(errorMessage ?? "")
                                .font(.custom("Outfit-Regular", size: 14))
                                .foregroundColor(.red)
                                .multilineTextAlignment(.leading)
                                .opacity(errorMessage == nil ? 0 : 1)
                        }
                        .frame(height: 1) // fixed height for the error area
                        
                        // Signup Button
                        ButtonView(title: "Sign up", action: {Task {
                            if validatePassword() {
                                do {
                                    try await viewModel.createUser(withEmail: email, password: password, username: username)
                                } catch let error as NSError {
                                    // Handle Firebase-specific errors
                                    if let authError = AuthErrorCode(rawValue: error.code) {
                                        switch authError {
                                        case .emailAlreadyInUse:
                                            errorMessage = "The email address is already taken."
                                        default:
                                            errorMessage = "Failed to create an account. Please try again."
                                        }
                                    } else {
                                        errorMessage = "An unexpected error occurred. Please contact support."
                                    }
                                }
                            }
                        }})
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    // Terms of Service and Privacy Policy
                    VStack {
                        (
                            Text("ⓘ By tapping 'Sign up', you agree to our ")
                            + Text("Terms of Service").underline()
                            + Text(" and ")
                            + Text("Privacy Policy").underline()
                            + Text(".")
                        )
                        .multilineTextAlignment(.center)
                    }
                    .font(.custom("Outfit-Regular", size: 15))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 15)
                    .padding(.bottom, 35)
                    
                    // Already have an account? Log in button
                    Button(action: {
                        dismiss() // Dismiss the signup view to return to login
                    }) {
                        HStack(spacing: 3) {
                            Text("Already have an account?")
                                .font(.custom("Outfit-Regular", size: 17))
                                .foregroundColor(.primary)
                            Text("Log in")
                                .font(.custom("Outfit-Bold", size: 17))
                                .foregroundColor(Color("primary")) // Use your custom primary color here
                                .underline()
                        }
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: - Password Validation
    private func validatePassword() -> Bool {
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return false
        }
        
        if password.count < 8 {
            errorMessage = "Password must be at least 8 characters long."
            return false
        }
        
        let uppercaseLetter = CharacterSet.uppercaseLetters
        let lowercaseLetter = CharacterSet.lowercaseLetters
        let number = CharacterSet.decimalDigits
        let specialCharacter = CharacterSet.punctuationCharacters.union(.symbols)
        
        if !password.unicodeScalars.contains(where: { uppercaseLetter.contains($0) }) {
            errorMessage = "Password must include at least one uppercase letter."
            return false
        }
        
        if !password.unicodeScalars.contains(where: { lowercaseLetter.contains($0) }) {
            errorMessage = "Password must include at least one lowercase letter."
            return false
        }
        
        if !password.unicodeScalars.contains(where: { number.contains($0) }) {
            errorMessage = "Password must include at least one number."
            return false
        }
        
        if !password.unicodeScalars.contains(where: { specialCharacter.contains($0) }) {
            errorMessage = "Password must include at least one special character."
            return false
        }
        
        errorMessage = nil
        return true
    }
}

#Preview {
    SignupView()
}
