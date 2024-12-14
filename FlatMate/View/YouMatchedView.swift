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

private func calculateAge(from dob: Date) -> Int {
    let calendar = Calendar.current
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: dob, to: now)
    return ageComponents.year ?? 0
}

struct YouMatchedView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var isOpen: Bool
    @Binding var navigateToMessagesView: Bool
    var thisUser: User
    var otherUser: ProfileCardView.Model

    var body: some View {
        NavigationStack {
            VStack {
                Text("It's a Match!")
                    .font(.custom("Outfit-Bold", size: 48))
                    .foregroundStyle(Color("primary"))
                    .padding()
                
                Spacer()
                
                HStack {
                    VStack {
                        renderProfileImageFromUrl(otherUser.profileImageURL)
                        Text("\(otherUser.firstName), \(otherUser.age)")
                            .font(.custom("Outfit-Bold", size: 24))
                    }
                    .padding()
                    
                    VStack {
                        renderProfileImageFromUrl(thisUser.profileImageURL)
                        Text("\(thisUser.firstName ?? "You"), \(calculateAge(from: thisUser.dob!))")
                            .font(.custom("Outfit-Bold", size: 24))
                    }
                    .padding()
                }
                
                Spacer()
                
                HStack(spacing: 30) {
                    ButtonView(
                        title: "Keep Swiping",
                        action: {
                            isOpen = false
                        },
                        type: .outline
                    )
                    
                    ButtonView(
                        title: "Go to Matches",
                        action: {
                            navigateToMessagesView = true
                            isOpen = false
                        }
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 40)
            }
        }
    }
}

// Preview provider for development
struct YouMatchedView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleUser = User(
            id: "1",
            email: "test@example.com",
            username: "testuser",
            firstName: "John",
            lastName: "Doe",
            dob: Date(),
            hasCompletedOnboarding: true
        )
        
        let sampleOtherUser = ProfileCardView.Model(
            id: "2",
            firstName: "Jane",
            age: 25,
            gender: "Female",
            bio: "Hello!",
            roomState: "Looking",
            location: "Toronto",
            profileImageURL: nil,
            isSmoker: false,
            petsOk: true,
            noiseTolerance: 3.0,
            partyFrequency: "Sometimes",
            guestFrequency: "Sometimes"
        )
        
        YouMatchedView(
            isOpen: .constant(true),
            navigateToMessagesView: .constant(false),
            thisUser: sampleUser,
            otherUser: sampleOtherUser
        )
        .environmentObject(AuthViewModel())
    }
}
