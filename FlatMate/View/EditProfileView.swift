//
//  Edit_Profile.swift
//
//
//  Created by Anshi on 2024-10-22.
//

import SwiftUI

let genders = ["Female", "Male", "Non-binary"]
let frequencies = ["Never", "Sometimes", "Always"]

struct EditProfileView: View {
    @State private var firstname: String = ""
    @State private var lastname: String = ""
    @State private var age: String = ""
    @State private var bio: String = "" // Corrected: added a separate variable for bio
    @State private var isSmoker: Bool = false
    @State private var pets: Bool = false
    @State private var selectedGender: String = genders[0]
    @State private var selectedPartyFrequency: String = frequencies[0]
    @State private var selectedGuestFrequency: String = frequencies[0]
    @State private var noiseTolerance: Double = 0.0 // Range from 0.0 to 1.0
    
    var body: some View {
        NavigationView {
            Form {
                // First Name Text Field
                TextField("First Name", text: $firstname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Last Name Text Field
                TextField("Last Name", text: $lastname)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Age Text Field
                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Gender Picker
                Picker("Gender", selection: $selectedGender) {
                    ForEach(genders, id: \.self) { gender in
                        Text(gender).tag(gender)
                    }
                }
                
                // Personal Bio Text Field
                TextField("Personal Bio", text: $bio) // Corrected: uses 'bio' state variable
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 80) // Set a larger height for multiline text
                    .lineLimit(3) // Set line limit to allow for more content
                
                // Smoker Toggle
                Toggle("Smoker", isOn: $isSmoker)
                
                // Pets Allowed Toggle
                Toggle("Pets Allowed", isOn: $pets)
                
                // Party Frequency Picker
                Picker("Parties", selection: $selectedPartyFrequency) {
                    ForEach(frequencies, id: \.self) { frequency in
                        Text(frequency).tag(frequency)
                    }
                }
                Text("How often do you host parties?")
                    .font(.footnote)
                    .padding(.horizontal)
                
                // Guest Frequency Picker
                Picker("Guests", selection: $selectedGuestFrequency) {
                    ForEach(frequencies, id: \.self) { frequency in
                        Text(frequency).tag(frequency)
                    }
                }
                Text("How often do you have guests over?")
                    .font(.footnote)
                    .padding(.horizontal)
                
                // Noise Tolerance Slider
                VStack {
                    Text("Noise Tolerance")
                        .font(.headline)
                    HStack {
                        Text("Quiet")
                        Slider(value: $noiseTolerance, in: 0...1, step: 0.1)
                            .accentColor(.blue)
                        Text("Loud")
                    }
                    .padding()
                }
            }
            .navigationBarTitle("Edit Profile", displayMode: .large) // Fixed typo
        }
    }
}

struct EditProfileView_Preview: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
