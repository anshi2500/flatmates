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
    
    // For showing the LocationSearchView as a sheet
    @State private var showingLocationSheet = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Title
            Text("Settings")
                .font(.custom("Outfit-Bold", size: 28))
                .padding(.leading)
            
            Divider()
            
            // ======= Change Password Button =======
            ButtonView(title: "Change Password") {
                viewModel.showPasswordChangeAlert = true
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 15)
            .frame(width: 400)
            .foregroundColor(.white)
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
            .fixedSize()
            
            Divider()
            
            // ======= Change Location Button =======
            ButtonView(title: "Change Location") {
                showingLocationSheet = true
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 15)
            .frame(width: 400)
            .foregroundColor(.white)
            
            // If a new location is chosen, show the "Save Location" button
            
            
            Divider()
            
            // ======= Delete Account Button =======
            ButtonView(title: "Delete Account") {
                viewModel.showDeleteAccountAlert = true
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 15)
            .frame(width: 400)
            .foregroundColor(.white)
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
            .fixedSize()
            
            Divider()
            
            if !viewModel.newLocation.isEmpty {
                Button(action: {
                    viewModel.updateLocation(authVM: authViewModel)
                }) {
                    Text("Save Location")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("primary"))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            
            // ======= Success or Loading Message =======
            if viewModel.isSuccessMessageVisible {
                Text(viewModel.successMessage)
                    .foregroundColor(.green)
                    .padding()
                    .transition(.opacity)
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
            }
        }
        .padding([.leading, .trailing])
        .frame(maxWidth: .infinity, alignment: .top)
        .edgesIgnoringSafeArea(.top)
        .background(Color.white)
        .fullScreenCover(isPresented: $showingLocationSheet) {
            // Present the LocationSearchView as a sheet
            // No changes needed in LocationSearchView
            LocationSearchView(
                selectedLocation: $viewModel.newLocation,
                city: $viewModel.city,
                province: $viewModel.province,
                country: $viewModel.country
            )
        }
        .fullScreenCover(isPresented: $viewModel.navigateToSignup) {
            LandingPageView()
        }
    }
}
