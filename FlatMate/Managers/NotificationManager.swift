//
//  NotificationManager.swift
//  FlatMate
//
//  Created by Ivan on 2025-03-09.
//

import Foundation
import FirebaseFirestore
import Combine

class NotificationManager: ObservableObject {
    // Singleton so we can call NotificationManager.shared
    static let shared = NotificationManager()
    
    @Published var notifications: [Notification] = []
    
    private var listenerRegistration: ListenerRegistration?
    
    // Private init to enforce singleton usage
    private init() {}
    
    // MARK: - Observe notifications in real-time
    func observeNotifications(for userID: String) {
        print("observeNotifications() called for userID: \(userID)")
        
        let db = Firestore.firestore()
        
        // Remove any existing listener
        listenerRegistration?.remove()
        
        listenerRegistration = db.collection("notifications")
            .whereField("receiverId", isEqualTo: userID)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Error observing notifications: \(error.localizedDescription)")
                    return
                }
                
                if let snapshot = snapshot {
                    print("observeNotifications snapshot has \(snapshot.documents.count) docs for userID: \(userID)")
                    let fetched = snapshot.documents.map { Notification(from: $0) }
                    self.notifications = fetched
                }
            }
    }
    
    func stopObserving() {
        print("stopObserving() called - removing listenerRegistration")
        listenerRegistration?.remove()
        listenerRegistration = nil
    }
    
    // fetch notifications
    func fetchNotifications(for userID: String, completion: @escaping (Result<[Notification], Error>) -> Void) {
        print("fetchNotifications() called for userID: \(userID)")
        
        let db = Firestore.firestore()
        
        db.collection("notifications")
            .whereField("receiverId", isEqualTo: userID)
            .order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error in fetchNotifications: \(error.localizedDescription)")
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    print("fetchNotifications got \(snapshot.documents.count) docs for userID: \(userID)")
                    let fetched = snapshot.documents.map { Notification(from: $0) }
                    completion(.success(fetched))
                }
            }
    }
    
    // Create a new notification
    func createNotification(
        receiverID: String,
        senderID: String,
        message: String,
        type: String,
        completion: @escaping (Error?) -> Void
    ) {
        print("createNotification() called for receiverID: \(receiverID), senderID: \(senderID), message: \(message), type: \(type)")
        
        let db = Firestore.firestore()
        
        let newNotification: [String: Any] = [
            "receiverId": receiverID,
            "senderId": senderID,
            "message": message,
            "timestamp": FieldValue.serverTimestamp(),
            "isRead": false,
            "status": "pending",
            "type": type
        ]
        
        db.collection("notifications")
            .addDocument(data: newNotification) { error in
                if let error = error {
                    print("Error adding notification doc: \(error.localizedDescription)")
                    completion(error)
                } else {
                    print("Successfully created notification doc for receiverID: \(receiverID)")
                    completion(nil)
                }
            }
    }
    
    // single notification as read
    func markNotificationAsRead(notificationID: String, completion: @escaping (Error?) -> Void) {
        print("markNotificationAsRead() called for notificationID: \(notificationID)")
        
        let db = Firestore.firestore()
        db.collection("notifications")
            .document(notificationID)
            .updateData(["isRead": true]) { error in
                if let error = error {
                    print("Error marking notification as read: \(error.localizedDescription)")
                } else {
                    print("Successfully marked notification \(notificationID) as read.")
                }
                completion(error)
            }
    }
    
    func markAllNotificationsAsRead(senderID: String, receiverID: String, completion: @escaping (Error?) -> Void = { _ in }) {
        print("markAllNotificationsAsRead() for senderID: \(senderID), receiverID: \(receiverID)")
        
        let db = Firestore.firestore()
        
        db.collection("notifications")
            .whereField("senderId", isEqualTo: senderID)
            .whereField("receiverId", isEqualTo: receiverID)
            .whereField("type", isEqualTo: "message") // message notifications
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching notifications to mark read: \(error.localizedDescription)")
                    completion(error)
                    return
                }
                
                guard let docs = snapshot?.documents else {
                    print("No notifications found to mark as read.")
                    completion(nil)
                    return
                }
                
                print("Found \(docs.count) notifications to mark as read for senderID \(senderID).")
                
                let batch = db.batch()
                for doc in docs {
                    batch.updateData(["isRead": true], forDocument: doc.reference)
                }
                
                batch.commit { batchError in
                    if let batchError = batchError {
                        print("Error batch-updating notifications: \(batchError.localizedDescription)")
                        completion(batchError)
                    } else {
                        print("Successfully marked all notifications from senderID: \(senderID) as read for receiverID: \(receiverID).")
                        completion(nil)
                    }
                }
            }
    }
}
