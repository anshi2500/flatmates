//
//  ContentView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isLoadingUser = true
    @State private var fakeProgress: Double = 0  // We'll animate this from 0 to 1
    
    var body: some View {
        Group {
            if isLoadingUser {
                // Custom Loading Screen
                VStack(spacing: 20) {
                    Text("Loading your data...")
                        .font(.headline)
                    
                    // Linear progress bar from 0..1
                    ProgressView(value: fakeProgress, total: 1.0)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .frame(width: 200)
                    
                    // Optional extra text
                }
                .onAppear {
                    // Animate our fake progress to 100% in ~2 seconds
                    withAnimation(.linear(duration: 2.0)) {
                        fakeProgress = 1.0
                    }
                }
                
            } else {
                // Once done loading, show real content
                if viewModel.userSession != nil {
                    if viewModel.hasCompletedOnboarding {
                        MainView()
                    } else {
                        OnboardingPageView(onComplete: {
                            Task {
                                do {
                                    try await viewModel.completeOnboarding()
                                } catch {
                                    print("DEBUG: Failed to mark onboarding as complete: \(error)")
                                }
                            }
                        })
                    }
                } else {
                    NavigationStack {
                        LandingPageView()
                    }
                }
            }
        }
        .task {
            // fetch the user from Firebase
            await viewModel.fetchUser()
            // Once the data is in, turn the loading flag off
            isLoadingUser = false
        }
    }
}



#Preview {
    ContentView()
}

