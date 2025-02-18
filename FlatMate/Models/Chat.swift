//
//  Chat.swift
//  FlatMate
//
//  Created by Joey on 2024-11-20.
//

import Foundation

struct Chat: Identifiable {
    let id: String
    let participants: [String] // List of userIDs involved (for now
    let lastMessage: String // Stored for later use (display on "Matches" screen
    let lastUpdated: Date // Stored for later use (display on "Matches" screen
}
