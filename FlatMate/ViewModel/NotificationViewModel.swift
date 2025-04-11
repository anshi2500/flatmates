//
//  NotificationViewModel.swift
//  FlatMate
//
//  Created by Ivan on 2025-03-09.
//

import SwiftUI
import Combine
import FirebaseAuth

class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        let userID = Auth.auth().currentUser?.uid
        print("NotificationViewModel init. currentUser?.uid = \(String(describing: userID))")
        
        // If user is logged in, start observing notifications in real time
        if let userID = userID {
            NotificationManager.shared.observeNotifications(for: userID)
        } else {
            print("No user logged in, not observing notifications.")
        }
        
        // Listen to changes from NotificationManager
        NotificationManager.shared.$notifications
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newNotifications in
                print("NotificationViewModel sink got \(newNotifications.count) notifications from manager.")
                self?.notifications = newNotifications
            }
            .store(in: &cancellables)
    }
    
    deinit {
        print("NotificationViewModel deinit -> stopping observe.")
        NotificationManager.shared.stopObserving()
    }
    
    // Computed property for unread count
    var unreadCount: Int {
        let count = notifications.filter { !$0.isRead }.count
        print("unreadCount computed -> \(count)")
        return count
    }
    
    // method to mark a notification as read
    func markAsRead(_ notification: Notification) {
        guard let id = notification.id else { return }
        print("markAsRead() for notificationID: \(id)")
        
        NotificationManager.shared.markNotificationAsRead(notificationID: id) { error in
            if let error = error {
                print("Failed to mark notification as read: \(error.localizedDescription)")
            } else {
                print("Notification \(id) marked as read.")
            }
        }
    }
    
    // fetch notification
    func loadNotificationsOnce() {
        guard let userID = Auth.auth().currentUser?.uid else {
            print("No user ID in loadNotificationsOnce()")
            return
        }
        
        print("loadNotificationsOnce() called for userID: \(userID)")
        
        NotificationManager.shared.fetchNotifications(for: userID) { [weak self] result in
            switch result {
            case .success(let fetched):
                print("loadNotificationsOnce -> fetched \(fetched.count) notifications.")
                DispatchQueue.main.async {
                    self?.notifications = fetched
                }
            case .failure(let error):
                print("Error fetching notifications once: \(error.localizedDescription)")
            }
        }
    }
}
