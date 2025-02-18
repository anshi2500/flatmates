//
//  Message.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id: String
    let senderID: String
    let receiverID: String
    let text: String
    let read: Bool
    let timestamp: Date
    var likes: [String] // Store user IDs of users who liked the message
    var likesCount: Int
}

