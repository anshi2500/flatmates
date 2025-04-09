//
//  SettingsProfileViewModel.swift
//  FlatMate
//
//  Created by AM on 17/02/2025.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
class SettingsProfileViewModel: ObservableObject {
    @Published var showPasswordChangeAlert = false
    @Published var errorMessage = ""
    @Published var isSuccessMessageVisible = false
    @Published var successMessage = "Password reset email sent. Check your inbox."
    @Published var showDeleteAccountAlert = false
    @Published var isDeletingAccount = false
    @Published var navigateToSignup = false
    @Published var isLoading = false
    
    @Published var newLocation: String = ""
       @Published var city: String = ""
       @Published var province: String = ""
       @Published var country: String = ""
       
       // Update location function
       func updateLocation(authVM: AuthViewModel) {
           guard let uid = authVM.currentUser?.id else {
               print("updateLocation: No user id")
               return
           }
           guard !newLocation.isEmpty else {
               print("updateLocation: newLocation is empty")
               return
           }
           
        
           print("updateLocation called with:")
           print("newLocation: \(newLocation)")
           print("city: \(city)")
           print("province: \(province)")
           print("country: \(country)")
           
           isLoading = true
           let db = Firestore.firestore()
           let data: [String: Any] = [
               "location": newLocation,
               "city": city,
               "province": province,
               "country": country
           ]
           db.collection("users").document(uid).setData(data, merge: true) { [weak self] error in
               guard let self = self else { return }
               self.isLoading = false
               if let error = error {
                   print("Error updating location: \(error.localizedDescription)")
                   self.successMessage = "Failed to update location."
               } else {
                   print("Successfully updated location to \(self.newLocation)")
                   self.successMessage = "Location updated!"
               }
               self.isSuccessMessageVisible = true
           }
       }
       
    
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
                    viewModel.signOut()  // Sign out the user
                    self.navigateToSignup = true  // Navigate to the signup screen
                }
                self.isDeletingAccount = false
            }
        }
    }
}
