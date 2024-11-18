//
//  MainView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-25.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab: BottomNavigationBar.Tab = .home

    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                // Home Tab
                SwipePageView()
                    .tabItem {
                        tabIcon(for: .home)
                        Text("Home")
                    }
                    .tag(BottomNavigationBar.Tab.home)

                // Search Tab
                MatchesView()
                    .tabItem {
                        tabIcon(for: .search)
                        Text("Search")
                    }
                    .tag(BottomNavigationBar.Tab.search)

                // Chat Tab
                MessagesView()
                    .tabItem {
                        tabIcon(for: .chat)
                        Text("Chat")
                    }
                    .tag(BottomNavigationBar.Tab.chat)

                // Profile Tab
                ProfileView()
                    .tabItem {
                        tabIcon(for: .profile)
                        Text("Profile")
                    }
                    .tag(BottomNavigationBar.Tab.profile)
            }
        }
    }

    @ViewBuilder
    private func tabIcon(for tab: BottomNavigationBar.Tab) -> some View {
        let color = Color(red: 255 / 255, green: 0, blue: 0) // Red color for selected icon

        switch tab {
        case .home:
            Image(systemName: selectedTab == .home ? "house.fill" : "house")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(selectedTab == .home ? color : .gray)
        case .search:
            Image(systemName: selectedTab == .search ? "magnifyingglass" : "magnifyingglass.circle")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(selectedTab == .search ? color : .gray)
        case .chat:
            Image(systemName: selectedTab == .chat ? "message.fill" : "message")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(selectedTab == .chat ? color : .gray)
        case .profile:
            Image(systemName: selectedTab == .profile ? "person.fill" : "person")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(selectedTab == .profile ? color : .gray)
        }
    }
}


#Preview {
    MainView()
}
