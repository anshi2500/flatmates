//
//  MatchRow.swift
//  FlatMate
//
//  Created by Youssef Abdelrhafour on 2024-11-17.
//

import SwiftUI

struct MatchRow: View {
    let name: String
    let imageURL: String // Updated to use imageURL
    //let messagePreview: String
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                // Profile Image
                AsyncImage(url: URL(string: imageURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        // Display a placeholder if there's an error
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.gray)
                    } else {
                        // Display a placeholder while loading
                        ProgressView()
                            .frame(width: 90, height: 90)
                    }
                }
                
                // Name and Message Preview
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.headline)
                    /*Text(messagePreview)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(1)*/ // Future iteration.
                }
                
                Spacer()
            }
            .padding(.vertical, 10) // Adjust spacing within rows
            
            // Separator Line
            Divider()
        }
    }
}

#Preview {
    MatchRow(
        name: "Alex Johnson",
        imageURL: "https://example.com/profile-picture.jpg"
        //messagePreview: "Hello!"
    )
}
