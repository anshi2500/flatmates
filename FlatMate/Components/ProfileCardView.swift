//
//  ProfileCardView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-10-20.
//

import SwiftUI

struct ProfileCardView: View {
    enum SwipeDirection {
        case left, right, none
    }

    struct Preferences: Equatable {
        let smoker: Bool
        let petsAllowed: Bool
        let wakingHours: Int
        let noiseTolerance: Int
        let partying: Int
        let guests: Int
    }

    // TODO: replace this with the profile model
    struct Model: Identifiable, Equatable {
        let id = UUID()
        let firstName: String
        let age: Int
        let gender: String
        let bio: String
        let hasPlace: Bool
        let neighbourhood: String
        let imageId: String
        let preferences: Preferences
        var swipeDirection: SwipeDirection = .none
    }

    private func renderTextWithEmoji(_ emoji: String, _ text: String) -> HStack<TupleView<(Text, Text)>> {
        HStack(alignment: .top, spacing: 15) {
            Text(emoji)
            Text(text)
        }
    }

    private func renderWakingHours(_ wakingHours: Int) -> HStack<TupleView<(Text, Text)>> {
        if wakingHours < 7 {
            return renderTextWithEmoji("🌅", "Early Riser")
        }
        if wakingHours < 10 {
            return renderTextWithEmoji("🛌", "Average Sleeper")
        }
        return renderTextWithEmoji("💤", "Late Sleeper")
    }

    private func renderPartying(_ partying: Int) -> HStack<TupleView<(Text, Text)>> {
        if partying < 4 {
            return renderTextWithEmoji(partying > 0 ? "✅" : "🚫", "Partying")
        }
        return renderTextWithEmoji("🪩", "Party Animal")
    }

    private func renderGuests(_ guests: Int) -> HStack<TupleView<(Text, Text)>> {
        if guests < 4 {
            return renderTextWithEmoji(guests > 0 ? "✅" : "🚫", "Guests")
        }
        return renderTextWithEmoji("🧑‍🤝‍🧑", "Loves Guests")
    }

    private func renderNoiseTolerance(_ noiseTolerance: Int) -> HStack<TupleView<(Text, Text)>> {
        if noiseTolerance < 4 {
            return renderTextWithEmoji(noiseTolerance > 0 ? "✅" : "🚫", "Noise")
        }
        return renderTextWithEmoji("🔊", "Unbothered by noise")
    }

    var profile: Model
    var size: CGSize
    var dragOffset: CGSize
    var isTopCard: Bool
    var isSecondCard: Bool

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .bottomLeading) {
                Image(profile.imageId)

                VStack(alignment: .leading) {
                    Text("\(profile.firstName), \(profile.age)").font(.custom("Outfit-Bold", size: 32)).colorInvert()
                    Text(profile.gender).colorInvert()
                    Text("\(profile.hasPlace ? "Spare room available" : "Looking for a room") in \(profile.neighbourhood)").colorInvert()
                }
                .font(.custom("Outfit-Semibold", size: 16))
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(
                    .rect(
                        topLeadingRadius: 0,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 20
                    )
                )
            }

            VStack(alignment: .leading, spacing: 6) {
                renderTextWithEmoji("🗣️", "“\(profile.bio)“")
                    .padding(.bottom)
                renderTextWithEmoji(profile.preferences.smoker ? "🚬" : "🚭", "\(profile.preferences.smoker ? "" : "No") Smoking")
                renderWakingHours(profile.preferences.wakingHours)
                renderTextWithEmoji(profile.preferences.petsAllowed ? "🐾" : "🚫", "\(profile.preferences.petsAllowed ? "Yes" : "No") Pets")
                renderNoiseTolerance(profile.preferences.noiseTolerance)
                renderPartying(profile.preferences.partying)
                renderGuests(profile.preferences.guests)
            }
            .padding()
        }
        .font(.custom("Outfit", size: 16))
        .frame(width: size.width, height: size.height, alignment: .bottomLeading)
        .padding(.bottom, 10)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: isTopCard ? getShadowColor() : (isSecondCard && dragOffset.width != 0 ? Color.gray.opacity(0.2) : Color.clear), radius: 10, x: 0, y: 3)
    }

    private func getShadowColor() -> Color {
        if dragOffset.width > 0 {
            return Color.green
        } else if dragOffset.width < 0 {
            return Color.red
        } else {
            return Color.gray.opacity(0.2)
        }
    }
}
