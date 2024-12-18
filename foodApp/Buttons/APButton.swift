//
//  Button.swift
//  foodApp
//
//  Created by Manish Agarwal on 16/12/24.
//

import SwiftUI

struct APButton: View {
    
    @Environment(\.colorScheme) var colorScheme
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 260, height: 50)
            .background(Color.brandPrimary)
            .foregroundColor(colorScheme == .dark ? .black : .white)
            .cornerRadius(10)
    }
}

#Preview {
    APButton(title: "Test Button")
}


