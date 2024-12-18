import SwiftUI

struct CartView: View {
    @StateObject private var viewModel: CartViewModel
    init(userId: String) {
        _viewModel = StateObject(wrappedValue: CartViewModel(userId: userId))
    }
    
    @State private var isLoading = true
    
    var body: some View {
        NavigationView {
            if Array(viewModel.cart.values).isEmpty {
               
                EmptyCart(imageName: "empty-order",
                           message: "You have no items in your order.\nPlease add an item!")
            } else {
                List {
                    ForEach(Array(viewModel.cart.values)) { item in
                        HStack{
                            CartItemRow(item: item)
                            Spacer()
                            VStack(spacing: 4) {
                                Button(action: {
                                    viewModel.increaseQuantity(for: item.id)
                                }) {
                                    Image(systemName: "plus.square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.brandPrimary)
                                }
                                
                                Text("\(item.quantity)")
                                Button(action: {
                                    viewModel.decreaseQuantity(for: item.id)
                                }) {
                                    Image(systemName: "minus.square")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.red)
                                }
                                
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .listRowSeparator(.hidden)
                    HStack {
                        Spacer()
                        APButton(title: "\(String(format: "$%.2f", calculateTotalPrice())) - Place Order")
                        Spacer()
                    }
                    .padding(.top)
                    .listRowInsets(EdgeInsets()) // Remove row insets for button row
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Cart")

            }
        }
        .onAppear {
            Task {
                print(viewModel.cart.isEmpty)
                await viewModel.fetchCartFromServer()
            }
        }
    }
    
    private func calculateTotalPrice() -> Double {
        return viewModel.cart.values.reduce(0) { total, item in
            total + (item.price * Double(item.quantity))
        }
    }
}

struct CartItemRow: View {
    let item: CartItem
    @State private var itemDetails: Item?

    var body: some View {
        HStack {
            if let details = itemDetails {
                AsyncImage(url: URL(string: details.imageURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                } placeholder: {
                    Image("food-placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                VStack(alignment: .leading, spacing: 5){
                    Text(details.name)
                        .fontWeight(.medium)
                    Text("$\(details.price * Double(item.quantity), specifier: "%.2f")")
                        .foregroundStyle(.secondary)
                        .fontWeight(.semibold)
                    
                }
                .padding(.leading)
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                    .padding(.leading)
                    .padding()
            }
        }
        .onAppear {
            fetchItem(byId: Int(item.id) ?? 0) { fetchedItem in
                self.itemDetails = fetchedItem
            }
        }
    }
}

#Preview {
    CartView(userId: "67628539334cf50b36c0aebd")
}
