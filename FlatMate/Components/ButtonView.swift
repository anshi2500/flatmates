//
//  ButtonView.swift
//  FlatMate
//
//  Created by 李吉喆 on 2024-10-18.
//

import SwiftUI

struct ButtonView: View {
    let title: String
    
    var body: some View {
        Button {} label: {
            HStack {
                Text(title)
                    .font(.custom("Outfit-Medium", size: 17))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, minHeight: 48) // Adjusted frame
        }
        .background(Color("primary"))
        .cornerRadius(10)
        .padding(.top, 24)
    }
}

#Preview {
    ButtonView(title: "Log In")
}
