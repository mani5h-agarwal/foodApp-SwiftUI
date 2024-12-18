//
//  AccountView.swift
//  foodApp
//
//  Created by Manish Agarwal on 17/12/24.
//

import SwiftUI


struct AccountView: View {
    @State private var fullName: String = UserDefaults.standard.string(forKey: "userFullName") ?? "N/A"
    @State private var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? "N/A"
    @State private var isLoggedOut: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(alignment: .trailing) {
                VStack(alignment: .leading) {
                    Text("Full Name")
                        .foregroundColor(.gray)
                    Text(fullName)
                        .font(.title2)
                        .padding(.bottom, 10)
                    
                    Divider()
                    
                    Text("Email")
                        .foregroundColor(.gray)
                    Text(email)
                        .font(.body)
                }.padding()
//                    .background(Color.white)
                    .background(
                        colorScheme == .dark ? Color(.darkGray).opacity(0.2) : Color.white // Custom color handling
                    )
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.15), radius: 10)
                    .padding()
                
                Button {
                    logout { success in
                        if success {
                            isLoggedOut = true
                            
                        }
                    }
                }label: {
                    Text("LogOut")
                }
                .buttonStyle(.bordered)
                .tint(.red)
//                .controlSize()
                .padding(.trailing)
                
                Spacer()
                
            }
            .navigationTitle("Account")
            .onAppear {
                fullName = UserDefaults.standard.string(forKey: "userFullName") ?? "N/A"
                email = UserDefaults.standard.string(forKey: "userEmail") ?? "N/A"
            }
            .navigationDestination(isPresented: $isLoggedOut) {
                SignForm()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    AccountView()
}
