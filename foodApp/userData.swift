import Foundation
import SwiftUI

// Store the token globally (you could also store this in UserDefaults or a secure storage solution for persistence)
var authToken: String?

struct User: Codable {
    let _id: String
    let email: String
    let fullName: String
    let iat: Int
}

// The Response model represents the outer structure of the JSON response.
struct Response: Codable {
    let user: User
}

func fetchUserData(completion: @escaping (User?) -> Void) {
    // Retrieve the token from UserDefaults
    guard let token = UserDefaults.standard.string(forKey: "authToken") else {
        print("No token available")
        completion(nil) // Return nil if no token is found
        return
    }
    
    // Define the URL for the API request
    guard let url = URL(string: "http://localhost:8001/api/userData") else {
        print("Invalid URL")
        completion(nil) // Return nil if the URL is invalid
        return
    }
    
    // Set up the URL request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    
    // Create the URLSession
    let session = URLSession.shared
    
    // Create the data task
    let task = session.dataTask(with: request) { data, response, error in
        // Handle errors
        if let error = error {
            print("Error fetching data: \(error.localizedDescription)")
            completion(nil) // Return nil if there's an error
            return
        }
        
        // Check HTTP status code
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        
        // Parse the response data
        if let data = data {
            do {
                // Decode the JSON response into the Response model
                let decoder = JSONDecoder()
                let responseData = try decoder.decode(Response.self, from: data)
                
                // Access the user data
                let user = responseData.user
                // Return the User object through the completion handler
                completion(user)
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(nil) // Return nil if there's an error in decoding
            }
        } else {
            completion(nil) // Return nil if data is not available
        }
    }
    
    // Start the task
    task.resume()
}

//func signUp(fullName: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
//    guard let url = URL(string: "http://localhost:8001/api/user/signup") else {
//        print("Invalid URL")
//        completion(false, "Invalid URL")
//        return
//    }
//
//    // Create request
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    // Request body
//    let requestBody: [String: Any] = [
//        "fullName": fullName,
//        "email": email,
//        "password": password
//    ]
//    
//    do {
//        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
//    } catch {
//        print("Error creating JSON body: \(error.localizedDescription)")
//        completion(false, error.localizedDescription)
//        return
//    }
//    
//    // Perform the request
//    URLSession.shared.dataTask(with: request) { data, response, error in
//        if let error = error {
//            print("Error during sign-up: \(error.localizedDescription)")
//            completion(false, error.localizedDescription)
//            return
//        }
//        
//        if let httpResponse = response as? HTTPURLResponse {
//            print("HTTP Status Code: \(httpResponse.statusCode)")
//        }
//        
//        if let data = data {
//            do {
//                // Convert response data to a string to print it out
//                let responseBody = String(data: data, encoding: .utf8)
//                print("Signup Response: \(responseBody ?? "")")
//                
//                // Assuming the response contains a token (you can adjust this if your response format is different)
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let token = json["token"] as? String {
//                    // Store the token
//                    authToken = token
//                    UserDefaults.standard.set(token, forKey: "authToken")
//                    print("Signup successful, token received: \(token)")
//                    completion(true, token)  // Return success and token
//                } else {
//                    print("Signup failed, no token found in response")
//                    completion(false, "No token found in response")  // Return failure and message
//                }
//            } catch {
//                print("Error parsing sign-up response: \(error.localizedDescription)")
//                completion(false, error.localizedDescription)  // Return failure and error message
//            }
//        } else {
//            completion(false, "No data received")  // Handle case where no data is returned
//        }
//    }.resume()
//}

// Sign Up Function
func signUp(fullName: String, email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
    guard let url = URL(string: "http://localhost:8001/api/user/signup") else {
        print("Invalid URL")
        completion(false, "Invalid URL")
        return
    }

    // Create request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Request body
    let requestBody: [String: Any] = [
        "fullName": fullName,
        "email": email,
        "password": password
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
    } catch {
        print("Error creating JSON body: \(error.localizedDescription)")
        completion(false, error.localizedDescription)
        return
    }
    
    // Perform the request
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error during sign-up: \(error.localizedDescription)")
            completion(false, error.localizedDescription)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        
        if let data = data {
            do {
                // Convert response data to a string to print it out
                let responseBody = String(data: data, encoding: .utf8)
                print("Signup Response: \(responseBody ?? "")")
                
                // Assuming the response contains user data and token
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String,
                   let user = json["user"] as? [String: Any] {
                    // Store the token and user data in UserDefaults
                    UserDefaults.standard.set(token, forKey: "authToken")
                    UserDefaults.standard.set(user["_id"] as? String, forKey: "userId")
                    UserDefaults.standard.set(user["email"] as? String, forKey: "userEmail")
                    UserDefaults.standard.set(user["fullName"] as? String, forKey: "userFullName")
                    
                    print("Signup successful, token received: \(token)")
                    completion(true, token)  // Return success and token
                } else {
                    print("Signup failed, no token or user found in response")
                    completion(false, "No token or user found in response")  // Return failure and message
                }
            } catch {
                print("Error parsing sign-up response: \(error.localizedDescription)")
                completion(false, error.localizedDescription)  // Return failure and error message
            }
        } else {
            completion(false, "No data received")  // Handle case where no data is returned
        }
    }.resume()
}

// Sign In Function
func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
    guard let url = URL(string: "http://localhost:8001/api/user/signin") else {
        print("Invalid URL")
        completion(false)
        return
    }

    // Create request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Request body
    let requestBody: [String: Any] = [
        "email": email,
        "password": password
    ]
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
    } catch {
        print("Error creating JSON body: \(error.localizedDescription)")
        completion(false)
        return
    }
    
    // Perform the request
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error during sign-in: \(error.localizedDescription)")
            completion(false)
            return
        }
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        
        if let data = data {
            do {
                // Assuming the response contains the token and user data in the body
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String,
                   let user = json["user"] as? [String: Any] {
                    // Store the token and user data in UserDefaults
                    UserDefaults.standard.set(token, forKey: "authToken")
                    UserDefaults.standard.set(user["_id"] as? String, forKey: "userId")
                    UserDefaults.standard.set(user["email"] as? String, forKey: "userEmail")
                    UserDefaults.standard.set(user["fullName"] as? String, forKey: "userFullName")
                    
                    print("Signin successful, token received: \(token)")
                    completion(true)  // Return success
                } else {
                    print("Signin failed, no token or user found in response")
                    completion(false)
                }
            } catch {
                print("Error parsing sign-in response: \(error.localizedDescription)")
                completion(false)
            }
        }
    }.resume()
}

// Logout Function
func logout(completion: @escaping (Bool) -> Void) {
    // Clear user data
    UserDefaults.standard.removeObject(forKey: "authToken")
    UserDefaults.standard.removeObject(forKey: "userId")
    UserDefaults.standard.removeObject(forKey: "userEmail")
    UserDefaults.standard.removeObject(forKey: "userFullName")
    
    // Confirm logout
    let isLoggedOut = UserDefaults.standard.string(forKey: "authToken") == nil
    if isLoggedOut {
        print("User logged out successfully.")
        completion(true)  // Notify success
    } else {
        print("Logout failed.")
        completion(false) // Notify failure
    }
}
