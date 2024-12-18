//
//  ListCell.swift
//  foodApp
//
//  Created by Manish Agarwal on 17/12/24.
//

import SwiftUI

struct ListCell: View {
    
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

#Preview {
    ListCell(items: MockData.sampleAppetizer)
}

struct MockData {
    
    static let sampleAppetizer = Item(id: 0001,
                                      name: "Test Appetizer",
                                      description: "This is the description for my appetizer. It's yummy.",
                                      protein: 99,
                                      calories: 99,
                                      imageURL: "https://seanallen-course-backend.herokuapp.com/images/appetizers/asian-flank-steak.jpg",
                                      price: 9.99,
                                      carbs: 99)
}
