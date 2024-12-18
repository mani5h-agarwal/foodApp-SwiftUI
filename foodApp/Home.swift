//
//  Home.swift
//  foodApp
//
//  Created by Manish Agarwal on 16/12/24.
//

import SwiftUI

struct Home: View {
    @State private var items: [Item] = []
    @State private var isLoading = false
    @State var isShowingDetail: Bool = false
    @State private var selectedItem: Item?
    @State private var hasLoadedData = false
    
    var body: some View {
        ZStack{
            
            NavigationView {
                Group {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                            .scaleEffect(2)
                    } else {
                        List(items) { item in
                            ListCell(items: item)
                                .onTapGesture {
                                    selectedItem = item
                                    isShowingDetail = true
                                }
                        }
                        .listStyle(PlainListStyle())
                        .disabled(isShowingDetail)
                        .navigationTitle("Home")
                    }
                }
                .onAppear {
                    if !hasLoadedData {
                        loadData()
                        hasLoadedData = true
                    }
                }
            }
            .onAppear {
                isShowingDetail = false // Reset `isShowingDetail` when Home appears
            }
            .blur(radius: isShowingDetail ? 20 : 0)
            if isShowingDetail {
                DetailView(isShowingDetail: $isShowingDetail, item: selectedItem!, cartViewModel: CartViewModel(userId: UserDefaults.standard.string(forKey: "userId")!))
            }


        }
        
    }
    
    func loadData() {
        isLoading = true
        fetchItemsData { fetchedItems in
            self.items = fetchedItems
            isLoading = false
        }
    }
}

#Preview {
    Home()
}
