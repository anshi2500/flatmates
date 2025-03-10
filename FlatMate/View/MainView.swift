//
//  MainView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-25.
//

import SwiftUICore
import SwiftUI

struct MainView: View {
    @State private var selectedTab: BottomNavigationBar.Tab = .home
    @State private var navigateToMessagesView: Bool = false
    
    // Create the notification view model
    @StateObject var notificationVM = NotificationViewModel()
    
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                
                // Home Tab
                SwipePageView(navigateToMessagesView: $navigateToMessagesView)
                    .tabItem {
                        tabIcon(for: .home)
                        Text("Home")
                    }
                    .tag(BottomNavigationBar.Tab.home)
                
                // Chat Tab
                MessagesView()
                    .environmentObject(notificationVM)
                    .tabItem {
                        tabIcon(for: .chat)
                        Text("Chat")
                    }
                    // Show the unread count as a badge by passing the computed value directly
                    .badge(notificationVM.unreadCount)
                    .tag(BottomNavigationBar.Tab.chat)
                
                // Profile Tab
                ProfileView()
                    .tabItem {
                        tabIcon(for: .profile)
                        Text("Profile")
                    }
                    .tag(BottomNavigationBar.Tab.profile)
            }
            .onChange(of: navigateToMessagesView) { newValue in
                if newValue {
                    selectedTab = .chat
                    navigateToMessagesView = false  // Reset after navigation
                }
            }
        }
    }
    
    @ViewBuilder
    private func tabIcon(for tab: BottomNavigationBar.Tab) -> some View {
        let color = Color("primary")
        
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
