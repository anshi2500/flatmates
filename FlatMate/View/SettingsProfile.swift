//
//  SettingsProfile.swift
//  FlatMate
//
//  Created by AM on 17/02/2025.
//

import SwiftUI

struct SettingsProfile: View {
    @StateObject private var viewModel = SettingsProfileViewModel()
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Text("Hello, World!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()
            
            // Change Password Button
            Button("Change Password") {
                viewModel.showPasswordChangeAlert = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .alert(isPresented: $viewModel.showPasswordChangeAlert) {
                Alert(
                    title: Text("Password Reset"),
                    message: Text("We will send you a link to reset your password."),
                    primaryButton: .default(Text("Send Email"), action: {
                        viewModel.sendPasswordResetEmail()
                    }),
                    secondaryButton: .cancel()
                )
            }
            
            if viewModel.isSuccessMessageVisible {
                Text(viewModel.successMessage)
                    .foregroundColor(.green)
                    .padding()
                    .transition(.opacity)
            }
            
            // Delete Account Button
            Button("Delete Account") {
                viewModel.showDeleteAccountAlert = true
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            .alert(isPresented: $viewModel.showDeleteAccountAlert) {
                Alert(
                    title: Text("Delete Account"),
                    message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        viewModel.deleteAccount(viewModel: authViewModel)
                    },
                    secondaryButton: .cancel()
                )
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
        .padding()
        .fullScreenCover(isPresented: $viewModel.navigateToSignup) {
            LandingPageView()  // Navigates to the signup screen
        }
    }
}
