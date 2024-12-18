//
//  DismissButton.swift
//  foodApp
//
//  Created by Manish Agarwal on 16/12/24.
//

import SwiftUI

struct DismissButton: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(Color.white)
                .opacity(0.6)
            Image(systemName: "xmark")
                .imageScale(.small)
                .frame(width: 44, height: 44)
                .foregroundColor(.black)
        }
    }
}

#Preview {
    DismissButton()
}
