//
//  SettingsProfileViewModel.swift
//  FlatMate
//
//  Created by AM on 17/02/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class SettingsProfileViewModel: ObservableObject {
    @Published var showPasswordChangeAlert = false
    @Published var errorMessage = ""
    @Published var isSuccessMessageVisible = false
    @Published var successMessage = "Password reset email sent. Check your inbox."
    @Published var showDeleteAccountAlert = false
    @Published var isDeletingAccount = false
    @Published var navigateToSignup = false
    
    @Published var isLoading = false
    
    func sendPasswordResetEmail() {
        guard let userEmail = Auth.auth().currentUser?.email else {
            errorMessage = "User email not found."
            return
        }
        
        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: userEmail) { error in
            if let error = error {
                self.errorMessage = "Error sending reset email: \(error.localizedDescription)"
            } else {
                self.errorMessage = ""
                self.isSuccessMessageVisible = true
                
                // Hide success message after 5 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.isSuccessMessageVisible = false
                }
            }
            self.isLoading = false
        }
    }
    
    func deleteAccount(viewModel: AuthViewModel) {
        isDeletingAccount = true
        
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        // Reference to the Firestore database
        let db = Firestore.firestore()
        
        // Assuming your users are stored in a collection called "users" with the document ID being the user's UID
        let userDocRef = db.collection("users").document(currentUser.uid)
        
        // First, delete user data from Firestore
        userDocRef.delete { error in
            if let error = error {
                self.errorMessage = "Error deleting user data from Firestore: \(error.localizedDescription)"
                self.isDeletingAccount = false
                return
            }
            
            // After Firestore deletion, delete user from Firebase Auth
            currentUser.delete { error in
                if let error = error {
                    self.errorMessage = "Error deleting account from Firebase Auth: \(error.localizedDescription)"
                } else {
                    // Account deleted successfully, handle navigation or logout
                    viewModel.signOut()  // Assuming signOut() will log the user out
                    self.navigateToSignup = true  // Navigate to the signup screen
                }
                self.isDeletingAccount = false
            }
        }
    }
}
