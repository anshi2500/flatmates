//
//  Message.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import Foundation

struct Message: Identifiable, Equatable {
    let id: String
    let text: String
    let received: Bool
    let timestamp: Date
}
