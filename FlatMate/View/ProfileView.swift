//
//  ProfileView.swift
//  FlatMate
//
//  Created by Jingke Huang on 2024-10-22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    // State variables to hold user data
    @State private var profileImage: UIImage? = nil
    @State private var name: String = ""
    @State private var age: Int = 0
    @State private var isLoading = true // State to show loading
    
    var body: some View {
        NavigationView {
            VStack {
                // Show loading spinner while data is being fetched
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 103)
                        .padding(.bottom, 20)
                    
                    // Display the profile image
                    if let image = profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .frame(width: 220, height: 220)
                            .padding(.top, 20)
                            .padding(.bottom, 5)
                            .shadow(radius: 10)
                    } else {
                        // Placeholder for missing profile image
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 220, height: 220)
                            .padding(.top, 20)
                            .padding(.bottom, 5)
                            .shadow(radius: 10)
                    }
                    
                    // Display the user's name and age
                    Text("\(name), \(age)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            ProfileButton(
                                icon: "settings_icon",
                                label: "SETTINGS",
                                isSelected: false,
                                action: { print("Settings tapped!") }
                            )
                            ProfileButton(
                                icon: "logout_icon",
                                label: "LOGOUT",
                                isSelected: false,
                                action: { viewModel.signOut() }
                            )
                        }
                        ProfileButton(
                            icon: "edit_icon",
                            label: "EDIT PROFILE",
                            isSelected: false,
                            destination: EditProfileView()
                        )
                    }
                    .padding(.bottom, 40)
                    
                    Spacer()
                }
            }
            .onAppear {
                fetchUserData()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // Fetch user data from Firebase
    private func fetchUserData() {
        guard let userID = viewModel.userSession?.uid else {
            print("User not logged in")
            return
        }
        
        let userDocRef = Firestore.firestore().collection("users").document(userID)
        userDocRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                isLoading = false
                return
            }
            
            guard let data = snapshot?.data() else {
                print("User data not found")
                isLoading = false
                return
            }
            
            // Populate fields with the fetched data
            name = "\(data["firstName"] as? String ?? "") \(data["lastName"] as? String ?? "")"
            if let dobTimestamp = data["dob"] as? Timestamp {
                let dob = dobTimestamp.dateValue()
                age = calculateAge(from: dob)
            }
            
            // Fetch profile image from Firebase Storage if it exists
            if let imageURLString = data["profileImageURL"] as? String,
               let url = URL(string: imageURLString) {
                loadImage(from: url)
            } else {
                isLoading = false // No image URL, stop loading
            }
        }
    }
    
    // Helper function to load an image from Firebase Storage
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching profile image: \(error.localizedDescription)")
                isLoading = false
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    profileImage = image
                    isLoading = false
                }
            } else {
                isLoading = false
            }
        }.resume()
    }
    
    // Helper function to calculate age from date of birth
    private func calculateAge(from dob: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
        return ageComponents.year ?? 0
    }
}

#Preview {
    ProfileView()
}
