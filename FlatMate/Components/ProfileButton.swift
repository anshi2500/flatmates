//
//  ProfileButton.swift
//  FlatMate
//
//  Created by Youssef Abdelrhafour on 2024-10-24.
//

import SwiftUI

struct ProfileButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    let selectedButtonColor = Color(red: 34/255, green: 87/255, blue: 122/255) // Color used in Figma for the selected button's background

    var body: some View {
        Button(action: action) {
            VStack {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(20)
                    .background(
                        Circle()
                            .fill(isSelected ? selectedButtonColor : Color.clear)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                Text(label)
            }
            .fontWeight(.bold)
            .font(.subheadline)
            .foregroundColor(.gray)
            .frame(width: 180)
        }
    }
}

#Preview {
    // Preview of the ProfileButton in selected and non-selected states
    VStack(spacing: 20) {
        ProfileButton(
            icon: "",
            label: "SETTINGS",
            isSelected: false,
            action: {}
        )
        
        ProfileButton(
            icon: "",
            label: "EDIT PROFILE",
            isSelected: true,
            action: {}
        )
        
        ProfileButton(
            icon: "",
            label: "LOG OUT",
            isSelected: false,
            action: {}
        )
    }
    .padding()
}

