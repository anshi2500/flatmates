//
//  FlatMateTests.swift
//  FlatMateTests
//
//  Created by 李吉喆 on 2024-10-18.
//

import Testing
import Firebase
@testable import FlatMate

struct FlatMateTests {
    
    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    }
    
    @Test func testFirebaseAccess() {
        let db = Firestore.firestore()
        let chatID = "62Bq8U0xkpa9Q01XvsAUcIay5pq1" // Replace with a valid chatID from your Firestore database
        
        db.collection("chats").document(chatID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching chat document: \(error.localizedDescription)")
                return
            }
            
            guard let data = snapshot?.data() else {
                print("No data found for chatID: \(chatID)")
                return
            }
            
            print("Data fetched for chatID \(chatID): \(data)")
        }
        
    }
}
