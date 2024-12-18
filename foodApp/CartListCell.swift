//
//  CartListCell.swift
//  foodApp
//
//  Created by Manish Agarwal on 18/12/24.
//

import SwiftUI

struct CartListCell: View {
    
    let items: Item
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: items.imageURL)) {
                image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
            } placeholder : {
                Image("food-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 90)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 5){
                Text(items.name)
                    .font(.title2)
                    .fontWeight(.medium)
                Text("$\(items.price, specifier: "%.2f")")
                    .foregroundStyle(.secondary)
                    .fontWeight(.semibold)
                
            }
            .padding(.leading)
        }
    }
}
