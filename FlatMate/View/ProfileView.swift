//
//  ProfileView.swift
//  FlatMate
//
//  Created by Jingke Huang on 2024-10-22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 103)
                .padding(.bottom, 20)

            Image("profileImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
                .frame(width: 220, height: 220)
                .padding(.top, 20)
                .padding(.bottom, 5)
                .shadow(radius: 10)

            Text("John, 25")
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ProfileView()
}
