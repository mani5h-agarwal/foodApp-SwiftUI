////
////  DetailView.swift
////  foodApp
////
////  Created by Manish Agarwal on 17/12/24.
////
//
import SwiftUI
//
//struct DetailView: View {
//    
//    @Binding var isShowingDetail: Bool
//    
//    var item: Item
//    var body: some View {
//        VStack {
//            AsyncImage(url: URL(string: item.imageURL)){ image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            }
//            placeholder : {
//                Image("food-placeholder")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//            }
//            VStack {
//                Text(item.name)
//                    .font(.title2)
//                    .fontWeight(.semibold)
//                Text(item.description)
//                    .multilineTextAlignment(.center)
//                    .font(.body)
//                    .padding()
//            }
//            HStack(spacing: 40) {
//                NutritionInfo(title: "Calories", value: "\(item.calories)")
//                NutritionInfo(title: "Carbs", value: "\(item.carbs) g")
//                NutritionInfo(title: "Protein", value: "\(item.protein) g")
//            }
//            Spacer()
//        
//            Button {
//                
//            } label: {
//                HStack(spacing: 10) {
//                    Text("$\(item.price, specifier: "%.2f") -")
////                    Text("Add to Order")
//                    QuantityCounter()
//                }
//                .frame(width: 170, height: 18)
//                .padding()
//                .background(Color.brandPrimary.opacity(0.18))
//                .cornerRadius(10)
//                .tint(.brandPrimary)
//            }
//            .padding(.bottom, 30)
//
//        }
//        .frame(width: 300, height: 525)
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(radius: 40)
//        .overlay(Button {
//            isShowingDetail = false
//        } label: {
//            DismissButton()
//        }, alignment: .topTrailing)
//    }
//}
//
//#Preview {
//    @Previewable @State var isShowingDetail = true
//    DetailView(isShowingDetail: $isShowingDetail, item: MockData.sampleAppetizer)
//}
//
//struct NutritionInfo: View {
//    
//    let title: String
//    let value: String
//    
//    var body: some View {
//        VStack(spacing: 5) {
//            Text(title)
//                .bold()
//                .font(.caption)
//            
//            Text(value)
//                .foregroundColor(.secondary)
//                .fontWeight(.semibold)
//                .italic()
//        }
//    }
//}
struct DetailView: View {
    
    @Binding var isShowingDetail: Bool
    var item: Item
    @ObservedObject var cartViewModel: CartViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: item.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Image("food-placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            
            VStack {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.semibold)
                Text(item.description)
                    .multilineTextAlignment(.center)
                    .font(.body)
                    .padding()
            }
            
            HStack(spacing: 40) {
                NutritionInfo(title: "Calories", value: "\(item.calories)")
                NutritionInfo(title: "Carbs", value: "\(item.carbs) g")
                NutritionInfo(title: "Protein", value: "\(item.protein) g")
            }
            Spacer()
            
            Button {
                if cartViewModel.cart[String(item.id)] == nil {
                    let cartItem = CartItem(id: String(item.id), name: item.name, price: item.price, quantity: 1)
                    cartViewModel.addToCart(item: cartItem)
                }
            } label: {
                HStack(spacing: 10) {
                    Text("$\(item.price, specifier: "%.2f") -")
                    if cartViewModel.cart[String(item.id)] != nil {
                        QuantityCounter(viewModel: cartViewModel, itemId: String(item.id))
                    } else {
                        Text("Add to Order")
                    }
                }
                .frame(width: 180, height: 18)
                .padding()
                .background(Color.brandPrimary.opacity(0.18))
                .cornerRadius(10)
                .tint(.brandPrimary)
            }
            .padding(.bottom, 30)
        }
        .frame(width: 300, height: 525)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 40)
        .overlay(Button {
            isShowingDetail = false
        } label: {
            DismissButton()
        }, alignment: .topTrailing)
        .onAppear {
            // Fetch updated cart data when returning to the view
            Task {
                await cartViewModel.fetchCartFromServer()
            }
        }
    }
}

struct NutritionInfo: View {
    
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .bold()
                .font(.caption)
            
            Text(value)
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
                .italic()
        }
    }
}

// Preview for the DetailView
#Preview {
    DetailView(
        isShowingDetail: .constant(true),
        item: MockData.sampleAppetizer,
        cartViewModel: CartViewModel(userId: "67617ea94ccbe97e9839becd")
    )
}
