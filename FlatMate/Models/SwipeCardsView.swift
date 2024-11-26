//
//  SwipeCardsView.swift
//  FlatMate
//
//  Created by Ben Schmidt on 2024-10-20.
//

import SwiftUI

struct SwipeCardsView: View {
    class Model: ObservableObject {
        private var originalCards: [ProfileCardView.Model]
        @Published var unswipedCards: [ProfileCardView.Model]
        @Published var swipedCards: [ProfileCardView.Model]
        @Published var lastSwipeDirection: ProfileCardView.SwipeDirection? // Track the last swipe direction
        
        init(cards: [ProfileCardView.Model]) {
            self.originalCards = cards
            self.unswipedCards = cards
            self.swipedCards = []
        }
        
        var currentCard: ProfileCardView.Model? {
            let card = unswipedCards.first
            print("Accessing currentCard: \(String(describing: card?.firstName))") // Debug print
            return card
        }
        
        func removeTopCard() {
            if !unswipedCards.isEmpty {
                let removedCard = unswipedCards.removeFirst()
                swipedCards.append(removedCard)
                print("Removed top card: \(removedCard.firstName)") // Debug print
            } else {
                print("No cards left to remove") // Debug print
            }
        }
        
        func updateTopCardSwipeDirection(_ direction: ProfileCardView.SwipeDirection) {
            lastSwipeDirection = direction
            print("Updated lastSwipeDirection to: \(direction)") // Debug print

            if !unswipedCards.isEmpty {
                unswipedCards[0].swipeDirection = direction
                print("Updated swipeDirection for top card: \(unswipedCards[0].firstName)") // Debug print
            }
        }
        
        func reset() {
            print("Resetting SwipeCardsView.Model") // Debug print
            unswipedCards = originalCards
            swipedCards = []
            lastSwipeDirection = nil
        }
    }
    
    @ObservedObject var model: Model
    @State private var dragState = CGSize.zero
    @State private var cardRotation: Double = 0
    
    private let swipeThreshold: CGFloat = 100.0
    private let rotationFactor: Double = 35.0
    
    var action: (Model) -> Void
    
    var body: some View {
        GeometryReader { geometry in
            if model.unswipedCards.isEmpty && model.swipedCards.isEmpty {
                emptyCardsView
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else if model.unswipedCards.isEmpty {
                swipingCompletionView
                    .frame(width: geometry.size.width, height: geometry.size.height)
            } else {
                ZStack {
                    Color.white.ignoresSafeArea()
                    
                    ForEach(model.unswipedCards.reversed()) { card in
                        let isTop = card == model.unswipedCards.first
                        let isSecond = card == model.unswipedCards.dropFirst().first
                        
                        ProfileCardView(
                            profile: card,
                            size: geometry.size,
                            dragOffset: dragState,
                            isTopCard: isTop,
                            isSecondCard: isSecond
                        )
                        .offset(x: isTop ? dragState.width : 0)
                        .rotationEffect(.degrees(isTop ? Double(dragState.width) / rotationFactor : 0))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    self.dragState = gesture.translation
                                    self.cardRotation = Double(gesture.translation.width) / rotationFactor
                                }
                                .onEnded { _ in
                                    if abs(self.dragState.width) > swipeThreshold {
                                        let swipeDirection: ProfileCardView.SwipeDirection = self.dragState.width > 0 ? .right : .left
                                        print("Swipe detected with direction: \(swipeDirection)")

                                        model.updateTopCardSwipeDirection(swipeDirection)

                                        withAnimation(.easeOut(duration: 0.5)) {
                                            self.dragState.width = self.dragState.width > 0 ? 1000 : -1000
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                            // Notify the parent view about the swipe
                                            action(model) // <-- Call the action closure here

                                            self.model.removeTopCard()
                                            self.dragState = .zero
                                            self.cardRotation = 0
                                        }
                                    } else {
                                        withAnimation(.spring()) {
                                            print("Swipe canceled, resetting card position")
                                            self.dragState = .zero
                                            self.cardRotation = 0
                                        }
                                    }
                                }
                        )
                        .animation(.easeInOut, value: dragState)
                        .ignoresSafeArea()
                    }
                }
            }
        }
    }
    
    var emptyCardsView: some View {
        VStack {
            Text("No Cards")
                .font(.title)
                .padding(.bottom, 20)
                .foregroundStyle(.gray)
        }
    }
    
    var swipingCompletionView: some View {
        VStack {
            Text("Finished Swiping")
                .font(.title)
                .padding(.bottom, 20)
            
            Button(action: {
                action(model)
            }) {
                Text("Reset")
                    .font(.headline)
                    .frame(width: 200, height: 50)
                    .background(Color.accentColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
}
