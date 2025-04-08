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
        NavigationView {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Settings")
                            .font(.custom("Outfit-Bold", size: 28))
                            .padding(.top, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Divider()
                    }
                    .padding(.horizontal, 25)
                    .background(Color.white)

                    ScrollView {
                        VStack(alignment: .leading, spacing: 15) {

                            // Change Password Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Change Password")
                                    .font(.custom("Outfit-Bold", size: 15))

                                Button(action: {
                                    viewModel.showPasswordChangeAlert = true
                                }) {
                                    Text("Change Password")
                                        .font(.custom("Outfit-Bold", size: 15))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .foregroundColor(.blue)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.blue, lineWidth: 2)
                                        )
                                }
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
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 1)

                            // Delete Account Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Delete Account")
                                    .font(.custom("Outfit-Bold", size: 15))

                                Button(action: {
                                    viewModel.showDeleteAccountAlert = true
                                }) {
                                    Text("Delete Account")
                                        .font(.custom("Outfit-Bold", size: 15))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.white)
                                        .foregroundColor(.red)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.red, lineWidth: 2)
                                        )
                                }
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
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 1)

                            if viewModel.isSuccessMessageVisible {
                                Text(viewModel.successMessage)
                                    .foregroundColor(.green)
                                    .font(.custom("Outfit-Bold", size: 15))
                                    .padding(.top)
                            }

                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                            }
                        }
                        .padding(.horizontal, 25)
                        .frame(minHeight: geometry.size.height * 0.8)
                    }
                    .background(Color.white)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .fullScreenCover(isPresented: $viewModel.navigateToSignup) {
            LandingPageView()
        }
    }
}
