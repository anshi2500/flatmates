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
        VStack(alignment: .leading, spacing: 20) {
            // Settings Title
            Text("Settings")
                .font(.custom("Outfit-Bold", size: 28))
                .padding(.leading)  // To add some space from the left edge
            
            Divider()  // Grey line beneath the title
            
            // Change Password Section
            VStack {
                HStack {
                    Text("Change Password")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)  // Align text to the left
                    
                    Button("Change Password") {
                        viewModel.showPasswordChangeAlert = true
                    }
                    
                    .padding(.horizontal,20)  // Padding for button
                    .padding(.vertical,15)
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
                    .fixedSize()  // Make the button fit its text size only
                }
            }
            
            Divider()  // Grey line beneath Change Password
            
            // Delete Account Section
            VStack {
                HStack {
                    Text("Delete Account")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)  // Align text to the left
                    
                    Button("Delete Account") {
                        viewModel.showDeleteAccountAlert = true
                    }
                    .padding(.horizontal,26)  // Padding for button
                    .padding(.vertical,15)
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
                    .fixedSize()  // Make the button fit its text size only
                }
            }

            Divider()  // Grey line beneath Delete Account
            
            // Success or Loading Message
            if viewModel.isSuccessMessageVisible {
                Text(viewModel.successMessage)
                    .foregroundColor(.green)
                    .padding()
                    .transition(.opacity)
            }
            
            // Loading Indicator
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
        .padding([.leading, .trailing])  // Horizontal padding for spacing
        .frame(maxWidth: .infinity, alignment: .top)  // Aligns the content to the top
        .edgesIgnoringSafeArea(.top)  // Ensure the content goes right to the top edge
        .background(Color.white)  // Background color to make sure the content area is clear
        .fullScreenCover(isPresented: $viewModel.navigateToSignup) {
            LandingPageView()  // Navigates to the signup screen
        }
    }
}
