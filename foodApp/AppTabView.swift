//
//  TabView.swift
//  foodApp
//
//  Created by Manish Agarwal on 16/12/24.
//

import SwiftUI

struct AppTabView: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)
            
            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person")
                }
                .tag(1)

            CartView(userId: UserDefaults.standard.string(forKey: "userId")!)
                .tabItem {
                    Label("Cart", systemImage: "bag")
                }
                .tag(2)
        }
    }
}



#Preview {
    AppTabView()
}
