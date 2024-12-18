//
//  EmptyCart.swift
//  foodApp
//
//  Created by Manish Agarwal on 16/12/24.
//

import SwiftUI

struct EmptyCart: View {
    
    let imageName: String
    let message: String
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 150)
            
            Text(message)
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding()
        }
        .offset(y: -50)
    }
}

#Preview {
    EmptyCart(imageName: "empty-order", message: "This is our test message.\nI'm making it a little long for testing.")
}
