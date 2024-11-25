//
//  ContentView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                if viewModel.hasCompletedOnboarding {
                    MainView()
                } else {
                    OnboardingPageView(onComplete: {
                        Task {
                            do {
                                try await viewModel.completeOnboarding() // Update Firebase and ViewModel
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
}

#Preview {
    ContentView()
}

