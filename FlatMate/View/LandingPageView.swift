//
//  LandingPageView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct LandingPageView: View {
    var body: some View {
        TabView {
            LandingPage(imageName: "landingPageImage-1", title: "Live with like-minded people.", description: "It’s easier than you think.")
            LandingPage(imageName: "landingPageImage-2", title: "Your Perfect Roommate is a Swipe Away", description: "Swipe right to like, left to pass. It’s that simple!")
            LandingPage(imageName: "landingPageImage-3", title: "Say Goodbye to Roommate Drama", description: "Find roommates who share your habits and lifestyle choices.")
            LandingPage(imageName: "landingPageImage-4", title: "Meet Your Perfect Roommate Today", description: "FlatMate makes it easy to find the right person, fast.")
            LoginView()
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

#Preview {
    LandingPageView()
}
