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
    let action: (() -> Void)?
    let destination: AnyView?

    // Initializer for actions
    init(icon: String, label: String, isSelected: Bool, action: @escaping () -> Void) {
        self.icon = icon
        self.label = label
        self.isSelected = isSelected
        self.action = action
        self.destination = nil
    }

    // Initializer for navigation
    init<Destination: View>(icon: String, label: String, isSelected: Bool, destination: Destination) {
        self.icon = icon
        self.label = label
        self.isSelected = isSelected
        self.destination = AnyView(destination)
        self.action = nil
    }

    var body: some View {
        Group {
            if let destination = destination {
                NavigationLink(destination: destination) {
                    buttonContent
                }
            } else if let action = action {
                Button(action: action) {
                    buttonContent
                }
            }
        }
    }

    // Shared button content
    private var buttonContent: some View {
        VStack {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .padding(20)
                .background(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.clear)
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


