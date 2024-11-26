//
//  TitleRow.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import SwiftUI
import FirebaseFirestore

struct TitleRow: View {
    var userID: String
    @State private var name: String = "Loading..."
    @State private var imageURL: String = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color("chatPrimary")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea(edges: .top)
            HStack(spacing: 20) {
                // Load the image from the provided URL or use a placeholder if it fails
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                    } else if phase.error != nil {
                        // Placeholder for error loading
                        Image(systemName: "person.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .cornerRadius(50)
                            .foregroundColor(.gray)
                    } else {
                        // Placeholder while loading
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                }
                
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title).bold()
                    
                    Text("Online")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .frame(height: 80)
        .onAppear {
            fetchUserData(userID: userID)
        }
    }
    
    // Fetch user data from Firestore
    // TODO: This is technical debt. This should be implemented into a ViewModel or a functionthat is accessible from anywhere
    func fetchUserData(userID: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID)
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let data = document.data()
                self.name = data?["firstName"] as? String ?? "Unknown User"
                self.imageURL = data?["profileImageURL"] as? String ?? ""
            } else {
                print("Document does not exist or error fetching: \(error?.localizedDescription ?? "Unknown error")")
                self.name = "Unknown User"
                self.imageURL = ""
            }
        }
    }
}

#Preview {
    TitleRow(userID: "sampleUserID")
}
