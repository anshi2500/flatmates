//
//  Edit_Profile.swift
//
//
//  Created by Anshi on 2024-10-22.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

let genders = ["Select an option", "Female", "Male", "Non-binary", "Other"]
let frequencies = ["Never", "Sometimes", "Always"]

struct EditProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    // Profile fields
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var dob: Date = Date()
    @State private var age: Int = 0
    @State private var bio: String = ""
    @State private var isSmoker: Bool = false
    @State private var petsOk: Bool = false
    @State private var selectedGender: String = genders[0]
    @State private var selectedPartyFrequency: String = frequencies[0]
    @State private var selectedGuestFrequency: String = frequencies[0]
    @State private var noise: Double = 0.0
    @State private var profileImage: UIImage? = nil
    @State private var errorMessage: String?
    @State private var updateSuccess: Bool = false
    @State private var showPickerOptions = false         // triggers confirmationDialog
    @State private var showPixabaySheet = false           // opens PixabaySearchView
    @State private var showLocalPhotoPicker = false       // opens local PhotosPicker
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 15) {
                    Spacer()
                    Text("Edit Profile")
                        .font(.custom("Outfit-Bold", size: 28))
                    Divider()
                    
                    // Profile Picture
                    HStack {
                        VStack {
                            ZStack {
                                if let image = profileImage {
                                    // user's currently chosen image
                                    Image(uiImage: image)
                                        .resizable()
                                        .clipShape(Circle())
                                        .frame(width: 100, height: 100)
                                } else {
                                    Circle()
                                        .fill(Color.gray)
                                        .frame(width: 100, height: 100)
                                }
                                
                                Button {
                                    // Show your pixabay sheet
                                    showPickerOptions = true
                                    
                                } label: {
                                    Image(systemName: "plus")
                                        .font(.system(size: 15, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                        .background(Circle().fill(Color("primary")))
                                        .shadow(radius: 5)
                                }
                                .offset(x: 35, y: 35)
                            }
                            
                        }
                        .padding(.trailing, 10)
                    }
                        // First Name, Last Name, Date of Birth
                    VStack(alignment: .leading) {
                            
                            HStack(spacing: 20){
                                Text("First Name")
                                    .font(.custom("Outfit-Bold", fixedSize: 18))
                                TextField(" ", text: $firstName)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                    .frame( height: 40)
                                
                            }
                            
                            HStack(spacing: 20){
                                Text("Last Name")
                                    .font(.custom("Outfit-Bold", fixedSize: 18))
                                TextField(" ", text: $lastName)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                                    .frame( height: 40)
                                
                            }
                            
                            
                            DatePicker("Date of Birth", selection: $dob, displayedComponents: .date)
                                 .font(.custom("Outfit-Bold", fixedSize: 18))
                                .onChange(of: dob) { newDate in
                                    age = calculateAge(from: newDate)
                                }
                        }
                    
                    
                    // Gender Picker
                    GenderPicker(selectedGender: $selectedGender)
                    
                    // Personal Bio
                    VStack(alignment: .leading) {
                        Text("Personal Bio")
                            .font(.custom("Outfit-Bold", fixedSize: 18))
                        TextEditor(text: $bio)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray, lineWidth: 1))
                    }
                    Divider()
                    
                    // Toggles
                    Toggle("I am a smoker.", isOn: $isSmoker)
                        .font(.custom("Outfit-Bold", fixedSize: 18))
                        .tint(Color("primary"))
                    Divider()
                    Toggle("I am a pet owner.", isOn: $petsOk)
                        .font(.custom("Outfit-Bold", fixedSize: 18))
                        .tint(Color("primary"))
                    Divider()
                    
                    // Party Frequency
                    VStack(alignment: .leading) {
                        Text("How often do you host parties?")
                            .font(.custom("Outfit-Bold", fixedSize: 18))
                        Picker("Parties", selection: $selectedPartyFrequency) {
                            ForEach(frequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Guest Frequency
                    VStack(alignment: .leading) {
                        Text("How often do you have guests over?")
                            .font(.custom("Outfit-Bold", fixedSize: 18))
                        Picker("Guests", selection: $selectedGuestFrequency) {
                            ForEach(frequencies, id: \.self) { frequency in
                                Text(frequency).tag(frequency)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Noise Tolerance Slider
                    VStack(alignment: .leading) {
                        Text("Noise Tolerance")
                            .font(.custom("Outfit-Bold", fixedSize: 18))
                        HStack {
                            Text("Quiet")
                            Slider(value: $noise, in: 0...5, step: 0.1)
                                .accentColor(Color("primary"))
                            Text("Loud")
                        }
                    }
                    
                    // Update Button
                    HStack {
                        ButtonView(title: "Update", action: { updateProfile() })
                            .padding(.horizontal, 16)
                            .padding(.vertical, -10)
                    }
                    .offset(y: -7)
                    .padding(.bottom, 30)
                }
                .padding(.horizontal, 25)
                .onAppear { fetchUserData() } // Load data when the view appears
            }
        }
        .alert(
            "Success",
            isPresented: $updateSuccess
        ) {
            Button("Ok") {
                updateSuccess = false
            }
        } message: {
            Text("Changes Updated Successfully")
        }.confirmationDialog("Select Photo Source", isPresented: $showPickerOptions, actions: {
            Button("Your Photos") {
                // Show the local PhotosPicker
                showLocalPhotoPicker = true
            }
            Button("Pixabay Photos") {
                // Show the Pixabay search sheet
                showPixabaySheet = true
            }
            Button("Cancel", role: .cancel) { }
        })

        .sheet(isPresented: $showLocalPhotoPicker) {
            PhotosPicker(
                selection: $selectedItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                //  UI label for the picker
                Text("Select a Photo").font(.headline)
            }
            .onChange(of: selectedItem) { newItem in
                guard let newItem else { return }
                Task {
                    if let data = try? await newItem.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        profileImage = uiImage
                    }
                    showLocalPhotoPicker = false // Dismiss the sheet after selection
                }
            }
        }
        
        .sheet(isPresented: $showPixabaySheet) {
            PixabaySearchView { selectedImage in
                
                if let urlStr = selectedImage.largeImageURL ?? selectedImage.webformatURL,
                   let url = URL(string: urlStr) {
                    Task {
                        do {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            if let downloadedImg = UIImage(data: data) {
                                self.profileImage = downloadedImg
                            }
                        } catch {
                            print("Error downloading chosen Pixabay image: \(error.localizedDescription)")
                        }
                    }
                }
                // Dismiss the sheet
                showPixabaySheet = false
            }
        }
    }
    
    // Fetch user data from Firebase
    private func fetchUserData() {
        guard let userID = viewModel.userSession?.uid else {
            errorMessage = "User not logged in"
            return
        }
        
        let userDocRef = Firestore.firestore().collection("users").document(userID)
        userDocRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                errorMessage = "Failed to fetch user data"
                return
            }
            
            guard let data = snapshot?.data() else {
                errorMessage = "User data not found"
                return
            }
            
            // Populate fields
            firstName = data["firstName"] as? String ?? ""
            lastName = data["lastName"] as? String ?? ""
            if let dobTimestamp = data["dob"] as? Timestamp {
                dob = dobTimestamp.dateValue()
                age = calculateAge(from: dob)
            }
            bio = data["bio"] as? String ?? ""
            isSmoker = data["isSmoker"] as? Bool ?? false
            petsOk = data["petsOk"] as? Bool ?? false
            selectedGender = data["gender"] as? String ?? genders[0]
            selectedPartyFrequency = data["partyFrequency"] as? String ?? frequencies[0]
            selectedGuestFrequency = data["guestFrequency"] as? String ?? frequencies[0]
            noise = data["noise"] as? Double ?? 0.0
            
            if let imageURLString = data["profileImageURL"] as? String,
               let url = URL(string: imageURLString) {
                loadImage(from: url)
            }
        }
    }
    
    // Load image from URL
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    profileImage = image
                }
            }
        }.resume()
    }
    
    // Update profile data
    private func updateProfile() {
        Task {
            do {
                try await viewModel.updateProfile(
                    firstname: firstName,
                    lastname: lastName,
                    dob: dob,
                    age: age, // Send age to backend
                    bio: bio,
                    isSmoker: isSmoker,
                    petsOk: petsOk,
                    gender: selectedGender,
                    partyFrequency: selectedPartyFrequency,
                    guestFrequency: selectedGuestFrequency,
                    noise: noise,
                    profileImage: profileImage
                )
                errorMessage = nil
                updateSuccess = true
            } catch {
                errorMessage = "Failed to update profile: \(error.localizedDescription)"
            }
        }
    }
    
    // Helper function to calculate age from date of birth
    private func calculateAge(from dob: Date) -> Int {
        let calendar = Calendar.current
        let now = Date()
        let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
        return ageComponents.year ?? 0
    }
}
