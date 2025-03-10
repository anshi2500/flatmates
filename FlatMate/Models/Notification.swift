//
//  Notification.swift
//  FlatMate
//
//  Created by Ivan on 2025-03-09.
//

import Foundation
import FirebaseFirestore

struct Notification: Identifiable {
    var id: String?           // Firestore document ID (optional)
    
    let receiverId: String    // The ID of the user receiving the notification
    let senderId: String      // The ID of the user sending the notification
    let message: String       // The notification message content
    let timestamp: Timestamp  // Timestamp when the notification was created
    let isRead: Bool          // Indicates if the notification has been read
    let status: String        // Status
    let type: String          // Type of notification
    
    // Initialize from a Firestore document snapshot
    init(from document: QueryDocumentSnapshot) {
        let data = document.data()
        self.id = document.documentID
        self.receiverId = data["receiverId"] as? String ?? ""
        self.senderId = data["senderId"] as? String ?? ""
        self.message = data["message"] as? String ?? "No message"
        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isRead = data["isRead"] as? Bool ?? false
        self.status = data["status"] as? String ?? ""
        self.type = data["type"] as? String ?? ""
    }
    
    // initializer for creating new notifications in code
    init(
        receiverId: String,
        senderId: String,
        message: String,
        timestamp: Timestamp = Timestamp(date: Date()),
        isRead: Bool = false,
        status: String = "pending",
        type: String
    ) {
        self.receiverId = receiverId
        self.senderId = senderId
        self.message = message
        self.timestamp = timestamp
        self.isRead = isRead
        self.status = status
        self.type = type
    }
}
