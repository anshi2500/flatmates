//
//  GenderPicker.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-11-17.
//

import SwiftUI

struct GenderPicker: View {
    @Binding var selectedGender: String
    let genders = ["Female", "Male", "Non-binary", "Other"]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Gender")
                .font(.headline)
            Picker("Select Gender", selection: $selectedGender) {
                ForEach(genders, id: \.self) { gender in
                    Text(gender).tag(gender)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    GenderPickerPreviewWrapper() // Use a wrapper view
}

struct GenderPickerPreviewWrapper: View {
    @State private var selectedGender = "Female" // State defined in a separate view

    var body: some View {
        GenderPicker(selectedGender: $selectedGender)
    }
}

