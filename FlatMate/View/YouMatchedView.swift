//
//  YouMatchedView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-11-26.
//

import SwiftUI

@ViewBuilder
func renderProfileImageFromUrl(_ profileUrl: String?) -> some View {
    if let profileImageURL = profileUrl, let url = URL(string: profileImageURL) {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(Circle())
        } placeholder: {
            ProgressView()
                .frame(width: 150, height: 150)
        }
    } else {
        // Default placeholder for users without a profile image
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
            .foregroundColor(.gray)
            .clipShape(Circle())
    }
}

// Helper function to calculate age from date of birth
// Copied from EditProfileView, we should probably make a utilities file
private func calculateAge(from dob: Date) -> Int {
    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
    return ageComponents.year ?? 0
}

struct YouMatchedView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    @Binding var isOpen: Bool
    var thisUser: User
    var otherUser: ProfileCardView.Model

    var body: some View {
        VStack {
            Text("It's a Match!")
                .font(.custom("Outfit-Bold", size: 48))
                .foregroundStyle(Color("primary"))
                .padding()
            Spacer()
            HStack {
                VStack {
                    renderProfileImageFromUrl(otherUser.profileImageURL)
                    Text("\(otherUser.firstName), \(otherUser.age)").font(.custom("Outfit-Bold", size: 24))
                }
                .padding()
                VStack {
                    renderProfileImageFromUrl(thisUser.profileImageURL)
                    Text("\(thisUser.firstName ?? "You"), \(calculateAge(from: thisUser.dob!))").font(.custom("Outfit-Bold", size: 24))
                }
                .padding()
            }
            Spacer()
            HStack(spacing: 30) {
                // Previous Button
                ButtonView(
                    title: "Keep Swiping",
                    action: {
                        isOpen = false
                    },
                    type: .outline
                )
                ButtonView(
                    title: "Send Message",
                    action: {
                        print("Goto chat page")
                        // TODO: navigate to chat page when its implemented
                    }
                )
            }
        }
        .padding()
    }
}
