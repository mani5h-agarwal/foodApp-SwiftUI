//
//  SignForm.swift
//  foodApp
//
//  Created by Manish Agarwal on 16/12/24.
//

import SwiftUI
import RegexBuilder

struct SignForm: View {
    
    @State private var selectedTab = "Sign In"
    @State private var success: Bool = false
    @State private var resetKey: UUID = UUID()

    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 50)
                
                Picker("Authentication", selection: $selectedTab) {
                    Text("Login").tag("Sign In")
                    Text("Signup").tag("Sign Up")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal, 30)
                .padding(.top, 20)

                if selectedTab == "Sign In" {
                    SignInView(success: $success)
                } else {
                    SignUpView(success: $success)
                }

                Spacer()
            }
            .onAppear {
                 checkIfUserIsLoggedIn()
             }
            .navigationDestination(isPresented: $success) {
                AppTabView()
                    .id(resetKey)
                        .onAppear {
                            resetKey = UUID() // Reset the key when navigating
                        }
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
    func checkIfUserIsLoggedIn() {
        // Check if token exists in UserDefaults
        if let token = UserDefaults.standard.string(forKey: "authToken"), !token.isEmpty {
            success = true // Automatically navigate to AppTabView
        }
    }
}

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @FocusState private var focusedField: Field?
    @State private var isPasswordVisible = false
    enum Field {
        case email, password
    }
    @Binding var success: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 20) {
            TextField("Email Address", text: $email)
                .focused($focusedField, equals: .email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(focusedField == .email ? Color.brandPrimary.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 1))
                .autocapitalization(.none)
                
            ZStack(alignment: .trailing) {
                if isPasswordVisible {
                    TextField("Password", text: $password)            .focused($focusedField, equals: .password)
                        .padding()
                   
                        .background(RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(focusedField == .password ? Color.brandPrimary.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 1))
                        .autocapitalization(.none)
                } else {
                    SecureField("Password", text: $password)      .focused($focusedField, equals: .password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(focusedField == .password ? Color.brandPrimary.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 1))
                        .autocapitalization(.none)
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                }
            }
            
            Button(action: {
                signIn(email: email, password: password) { value in
                    if value {
                        success = value
                    } else {
                        print("Sign-in failed")
                    }
                }
               
            }) {
                Text("Login")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandPrimary)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .cornerRadius(10)
            }
            
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @Binding var success: Bool
    @FocusState private var focusedField: Field?
        
        enum Field {
            case fullName, email, password
        }
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 20) {
            TextField("Full Name", text: $fullName)
                .focused($focusedField, equals: .fullName)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(focusedField == .fullName ? Color.brandPrimary.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 1))
                .autocapitalization(.none)
            
            TextField("Email", text: $email)
                .focused($focusedField, equals: .email)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(focusedField == .email ? Color.brandPrimary.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 1))
                .autocapitalization(.none)
            
            ZStack(alignment: .trailing) {
                if isPasswordVisible {
                    TextField("Password", text: $password)            .focused($focusedField, equals: .password)
                        .padding()
                   
                        .background(RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(focusedField == .password ? Color.brandPrimary.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 1))
                        .autocapitalization(.none)
                } else {
                    SecureField("Password", text: $password)      .focused($focusedField, equals: .password)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(focusedField == .password ? Color.brandPrimary.opacity(0.8) : Color.gray.opacity(0.5), lineWidth: 1))
                        .autocapitalization(.none)
                }
                
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                }
            }
            
            Button(action: {
                signUp(fullName: fullName, email: email, password: password){ value, message in
                    if value {
                        success = value
                    } else {
                        print("Signup failed: \(message ?? "")")
                    }
                }
               
            }) {
                Text("SignUp")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.brandPrimary)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .cornerRadius(10)
            }
        }
        .padding(.horizontal, 30)
        .padding(.top, 30)
    }
}
extension String {
    var isValidEmail: Bool {
        let emailRegex = Regex {
            OneOrMore {
                CharacterClass(
                    .anyOf("._%+-"),
                    ("A"..."Z"),
                    ("0"..."9"),
                    ("a"..."z")
                )
            }
            "@"
            OneOrMore {
                CharacterClass(
                    .anyOf("-"),
                    ("A"..."Z"),
                    ("a"..."z"),
                    ("0"..."9")
                )
            }
            "."
            Repeat(2...64) {
                CharacterClass(
                    ("A"..."Z"),
                    ("a"..."z")
                )
            }
        }

        return self.wholeMatch(of: emailRegex) != nil
    }
}

#Preview {
    SignForm()
}


