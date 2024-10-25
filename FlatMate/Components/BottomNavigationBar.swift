//
//  BottomNavigationBar.swift
//  FlatMate
//
//  Created by Jingke Huang on 2024-10-22.
//

import SwiftUI

struct BottomNavigationBar: View {
    // Active tab state
    @Binding var selectedTab: Tab

    // Enum to represent each tab
    enum Tab {
        case home
        case search
        case chat
        case profile
    }
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: {
                selectedTab = .home
            }) {
                Image(systemName: selectedTab == .home ? "house.fill" : "house")
                    .resizable()
                    .foregroundColor(selectedTab == .home ? Color(red: 34/255, green: 87/255, blue: 122/255) : Color.gray)
                    .frame(width: 30, height: 30)
            }
            Spacer()
            
            Button(action: {
                selectedTab = .search
            }) {
                Image(systemName: selectedTab == .search ? "magnifyingglass" : "magnifyingglass.circle")
                .resizable()
                .foregroundColor(selectedTab == .search ? Color(red: 34/255, green: 87/255, blue: 122/255) : Color.gray)
                .frame(width: 30, height: 30)
            }
            Spacer()
            
            Button(action: {
                selectedTab = .chat
            }) {
                Image(systemName: selectedTab == .chat ? "message.fill" : "message")
                .resizable()
                .foregroundColor(selectedTab == .chat ? Color(red: 34/255, green: 87/255, blue: 122/255) : Color.gray)
                .frame(width: 30, height: 30)
            }
            Spacer()
            
            Button(action: {
                selectedTab = .profile
            }) {
                Image(systemName: selectedTab == .profile ? "person.fill" : "person")
                .resizable()
                .foregroundColor(selectedTab == .profile ? Color(red: 34/255, green: 87/255, blue: 122/255) : Color.gray)
                .frame(width: 30, height: 30)
            }
            Spacer()
        }
        .padding()
        .background(Color.white)
        .clipShape(Capsule())
    }
}

#Preview {
    BottomNavigationBar(selectedTab: .constant(.profile)) // Preview with profile tab selected
}
