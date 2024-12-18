import SwiftUI

struct SampleCartView: View {
    @StateObject private var viewModel: CartViewModel
    
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: CartViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            List {
                // Displaying items in the cart
                ForEach(Array(viewModel.cart.values)) { item in
                    HStack {
                        // Item Name and Price
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text("Price: $\(item.price, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                        Spacer()
                        
                        // Buttons to adjust quantity
                        HStack {
                            Button(action: {
                                viewModel.decreaseQuantity(for: item.id) // Decrease quantity
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                            Text("\(item.quantity)")
                                .frame(width: 30)
                            Button(action: {
                                viewModel.increaseQuantity(for: item.id) // Increase quantity
                            }) {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.green)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("Cart")
            .onAppear {
                Task {
                    // Fetch the cart from the server when the view appears
                    await viewModel.fetchCartFromServer()
                }
            }
            .toolbar {
                // Add an item to the cart button
                Button("Add Item") {
                    // Sample item to add to the cart
                    let sampleItem = CartItem(id: "3", name: "Burger", price: 5.99, quantity: 1)
                    viewModel.addToCart(item: sampleItem) // Add item to cart
                }
            }
        }
    }
}

#Preview {
    SampleCartView(userId: "67617ea94ccbe97e9839becd")
}
