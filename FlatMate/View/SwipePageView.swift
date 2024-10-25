//
//  SwipePageView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-10-20.
//

import SwiftUI

struct SwipePageView: View {
    var body: some View {
        VStack {
            let cards = [
                ProfileCardView.Model(
                    firstName: "Jane",
                    age: 24,
                    gender: "Woman",
                    bio: "I'm a great cook and love to party!",
                    hasPlace: false,
                    neighbourhood: "Brentwood",
                    imageId: "Placeholder-Jane",
                    preferences: ProfileCardView.Preferences(
                        smoker: true,
                        petsAllowed: false,
                        wakingHours: 8,
                        noiseTolerance: 3,
                        partying: 3,
                        guests: 5
                    )
                ),
                ProfileCardView.Model(
                    firstName: "James",
                    age: 28,
                    gender: "Man",
                    bio: "Quiet, diligent student.",
                    hasPlace: true,
                    neighbourhood: "Northland",
                    imageId: "Placeholder-James",
                    preferences: ProfileCardView.Preferences(
                        smoker: false,
                        petsAllowed: true,
                        wakingHours: 12,
                        noiseTolerance: 0,
                        partying: 0,
                        guests: 0
                    )
                ),
                ProfileCardView.Model(
                    firstName: "Anaya",
                    age: 22,
                    gender: "Woman",
                    bio: "I love having friends over!",
                    hasPlace: false,
                    neighbourhood: "Montgomery",
                    imageId: "Placeholder-Anaya",
                    preferences: ProfileCardView.Preferences(
                        smoker: true,
                        petsAllowed: false,
                        wakingHours: 6,
                        noiseTolerance: 5,
                        partying: 5,
                        guests: 5
                    )
                ),
            ]

            let model = SwipeCardsView.Model(cards: cards)
            SwipeCardsView(model: model) { model in
                print(model.swipedCards)
                model.reset()
            }
        }
    }
}
