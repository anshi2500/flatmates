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
                MainView()
            } else {
                NavigationStack {
                    // Entry point of the app
                    LandingPageView()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

