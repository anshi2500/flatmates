//
//  MyProfileView.swift
//  FlatMate
//
//  Created by Jingke Huang on 2024-10-22.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedTab: BottomNavigationBar.Tab = .profile // Default to profile
    var userName: String = "John"
    var userAge: Int = 25
    
    // Add those variables for the next step: Adding logic
    @State private var isSettingClicked = false
    @State private var isEditProfileClicked = false
    @State private var isLogOutClicked = false
    
    // Color used in Figma for the selected button's background
    let selectedButtonColor = Color(red: 34/255, green: 87/255, blue: 122/255)
        

    var body: some View {
        VStack {
            // Logo at the top
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame(height: 103)
                .padding(.bottom, 20)
            
            Image("profileImage")
                .resizable()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.gray, lineWidth: 5))
                .frame(width: 200, height: 200)
                .padding(.top, 20)
                .padding(.bottom, 10)
                
            Text("\(userName) , \(userAge)")
                .font(.title)
                .fontWeight(.bold)

            Spacer()

            // Buttons: Settings, Edit Profile, Log Out
            VStack(spacing: 20) {
                HStack(spacing: 20) {
                    Button(action: {
                        // Setting button action
                        isSettingClicked.toggle()
                    }) {
                        VStack {
                            Image(systemName: "gearshape")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(20)
                                .background(
                                    Circle()
                                        .fill(isSettingClicked ? selectedButtonColor : Color.clear) // Change color when clicked
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 2)  // Circle stroke
                                                .shadow(radius: 5)  // Circle shadow
                                    )
                                )
                            Text("SETTING")
                        }
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(width: 180)
                        }

                    Button(action: {
                        // Log Out button action
                        isLogOutClicked.toggle()
                    }) {
                        VStack {
                            Image(systemName: "arrowshape.turn.up.left")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .padding(20)
                                .background(
                                    Circle()
                                        .fill(isLogOutClicked ? selectedButtonColor : Color.clear) // Change color when clicked
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray, lineWidth: 2)  // Circle stroke
                                                .shadow(radius: 5)  // Circle shadow
                                    )
                                )
                            Text("LOG OUT")
                        }
                        .fontWeight(.bold)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .frame(width: 180)
                        }
                    }
                
                // Edit Profile button centered
                Button(action: {
                    // Edit Profile button action
                    isEditProfileClicked.toggle()
                }) {
                    VStack {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .padding(25)
                            .background(
                                Circle()
                                    .fill(isEditProfileClicked ? selectedButtonColor : Color.clear) // Change color when clicked
                                    .overlay(
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 2)  // Circle stroke
                                            .shadow(radius: 5)  // Circle shadow
                                    )
                            )
                        Text("EDIT PROFILE")
                    }
                    .fontWeight(.bold)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .frame(width: 200)
                }
            }
            .padding(.bottom, 40)

            Spacer()

            // Bottom Navigation Bar
            BottomNavigationBar(selectedTab: $selectedTab)
        }
        .navigationBarBackButtonHidden(true) // Hide default back button
    }
}

#Preview {
    ProfileView()
}
