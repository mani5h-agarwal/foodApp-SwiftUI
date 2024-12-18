
import SwiftUI

// Quantity Counter that works directly with CartViewModel
struct QuantityCounter: View {
    @ObservedObject var viewModel: CartViewModel // ViewModel to access cart items
    var itemId: String // Item's ID to update quantity in the cart
    @State private var quantity: Int // Local quantity state
    
    init(viewModel: CartViewModel, itemId: String) {
        self.viewModel = viewModel
        self.itemId = itemId
        // Set the initial quantity based on the current item in the cart
        self._quantity = State(initialValue: viewModel.cart[itemId]?.quantity ?? 0)
    }
    
    var body: some View {
        
        HStack(spacing: 0) {
            // Decrease Button
            Button(action: {
                // Decrease quantity in the cart
                if quantity > 0 {
                    quantity -= 1
                    viewModel.decreaseQuantity(for: itemId)
                }
            }) {
                Image(systemName: "minus.square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.red)
            }
            
            // Display the current quantity
            Text("\(quantity)")
                .frame(width: 30)
            
            // Increase Button
            Button(action: {
                // Increase quantity in the cart
                quantity += 1
                viewModel.increaseQuantity(for: itemId)
            }) {
                Image(systemName: "plus.square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.brandPrimary)
            }
        }
        
    }
}
