//
//  TitleRow.swift
//  FlatMate
//
//  Created by Joey on 2024-11-18.
//

import SwiftUI

struct TitleRow: View {
    var name = "James"
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color("chatPrimary")]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
                .ignoresSafeArea(edges: .top)
            HStack(spacing: 20) {
                Image("Placeholder-James")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .cornerRadius(50)
                
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
    }
}

#Preview {
    TitleRow()
}

