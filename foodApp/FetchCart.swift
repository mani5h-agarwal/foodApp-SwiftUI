//
//  FetchCart.swift
//  foodApp
//
//  Created by Manish Agarwal on 17/12/24.
//

import SwiftUI

struct FetchCart: View {
    @StateObject private var viewModel: CartViewModel
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: CartViewModel(userId: userId))
    }
    var body: some View {
        
        Text("click me")
            .font(.title3)
            .fontWeight(.semibold)
            .frame(width: 260, height: 50)
            .foregroundColor(Color.white)
            .background(Color.brandPrimary)
            .cornerRadius(10)
            .onTapGesture {
                Task{
                    await viewModel.fetchCartFromServer()
                }
            }
    }
}

#Preview {
    FetchCart(userId: "67617ea94ccbe97e9839becd")
}
