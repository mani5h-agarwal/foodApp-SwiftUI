
import SwiftUI

// CartItem struct for individual items in the cart
struct CartItem: Identifiable, Codable {
    let id: String
    let name: String
    let price: Double
    var quantity: Int
}

class CartViewModel: ObservableObject {
    @Published var cart: [String: CartItem] = [:] // Cart data

    private let userId: String // User ID to identify cart

    init(userId: String) {
        self.userId = userId
        Task {
            await fetchCartFromServer() // Fetch cart from server when initializing
        }
    }

    // API Request Helper to update cart on the server
    private func updateCartOnServer(productId: String, quantityChange: Int, price: Double) async throws {
        let body: [String: Any] = [
            "userId": userId,
            "productId": productId,
            "price": price,
            "quantity": quantityChange
        ]
        
        guard let url = URL(string: "http://localhost:8001/api/cart/add"),
              let jsonBody = try? JSONSerialization.data(withJSONObject: body) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody
        
        let (_, response) = try await URLSession.shared.data(for: request)
        if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
            throw URLError(.badServerResponse)
        }
    }
    
    // Add an item to the cart
    func addToCart(item: CartItem) {
        Task {
            // Update cart locally first, before calling the API
            if var existingItem = cart[item.id] {
                existingItem.quantity += 1
                cart[item.id] = existingItem
            } else {
                cart[item.id] = item
            }
            
            // Try updating the cart on the server
            do {
                try await updateCartOnServer(productId: item.id, quantityChange: 1, price: item.price)
            } catch {
                print("Error adding to cart: \(error)")
                // Optionally, handle error by rolling back the cart update or showing a UI alert
            }
        }
    }
    
    // Increase quantity for a specific item
    func increaseQuantity(for itemId: String) {
        Task {
            if var item = cart[itemId] {
                item.quantity += 1
                cart[itemId] = item
                do {
                    try await updateCartOnServer(productId: itemId, quantityChange: 1, price: item.price)
                } catch {
                    print("Error increasing quantity: \(error)")
                }
            }
        }
    }
    
    // Decrease quantity for a specific item
    func decreaseQuantity(for itemId: String) {
        Task {
            if var item = cart[itemId] {
                item.quantity -= 1
                if item.quantity <= 0 {
                    cart.removeValue(forKey: itemId)
                } else {
                    cart[itemId] = item
                }
                do {
                    try await updateCartOnServer(productId: itemId, quantityChange: -1, price: item.price)
                } catch {
                    print("Error decreasing quantity: \(error)")
                }
            }
        }
    }
    
    // Fetch the cart from the server to sync with the latest data
    @MainActor
    func fetchCartFromServer() async {
        guard let url = URL(string: "http://localhost:8001/api/cart/\(userId)") else {
            print("Invalid URL for cart fetch")
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check for the HTTP response status
            if let httpResponse = response as? HTTPURLResponse {
                if !(200...299).contains(httpResponse.statusCode) {
                    if httpResponse.statusCode == 404 {
                        // Handle 404 as a missing cart, no data to fetch
                        print("No cart found for user: \(userId)")
                        // Set the cart to empty if 404, since no cart exists
                        self.cart = [:]
                        return
                    } else {
                        // For other errors, just print them
                        print("Error fetching cart: Invalid response \(httpResponse.statusCode)")
                        return
                    }
                }
            }
            
            // Proceed with decoding the server data if status code is 200-299
            let serverCart = try JSONDecoder().decode(ServerCart.self, from: data)
            updateLocalCart(with: serverCart)
            
        } catch {
            print("Error fetching cart: \(error)")
            // Optionally, handle the error by showing a UI alert or retrying
        }
    }
    
    // Update the local cart with the fetched server data
    private func updateLocalCart(with serverCart: ServerCart) {
        var updatedCart: [String: CartItem] = [:]
        
        for serverItem in serverCart.items {
            let cartItem = CartItem(
                id: serverItem.productId,
                name: serverItem.productId, // Replace with actual name if available
                price: serverItem.price,
                quantity: serverItem.quantity
            )
            updatedCart[serverItem.productId] = cartItem
        }
        
        DispatchQueue.main.async {
            self.cart = updatedCart
        }
    }
}

// Define a structure to match the cart response from the server
struct ServerCart: Codable {
    let items: [ServerCartItem]
}

struct ServerCartItem: Codable {
    let productId: String
    let quantity: Int
    let price: Double
}
