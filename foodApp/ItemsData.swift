//
//  ItemsDats.swift
//  foodApp
//
//  Created by Manish Agarwal on 17/12/24.
//

import Foundation

// Define the model based on your JSON structure
struct Item: Codable {
    let id: Int
    let name: String
    let description: String
    let protein: Int
    let calories: Int
    let imageURL: String
    let price: Double
    let carbs: Int
}

// Function to fetch data from the server
func fetchItemsData() {
    let urlString = "http://localhost:8001/api/itemsData"
    
    // Ensure the URL is valid
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    // Perform the GET request
    URLSession.shared.dataTask(with: url) { data, response, error in
        // Handle errors
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        // Check HTTP Response
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
        }
        
        // Ensure data is present
        guard let data = data else {
            print("No data received")
            return
        }
        
        // Decode JSON into the [Item] array
        do {
            let items = try JSONDecoder().decode([Item].self, from: data)
            print("Fetched Items:")
            for item in items {
                print("""
                ID: \(item.id)
                Name: \(item.name)
                Description: \(item.description)
                Protein: \(item.protein)
                Calories: \(item.calories)
                Carbs: \(item.carbs)
                Price: \(item.price)
                ImageURL: \(item.imageURL)
                ------------------------------
                """)
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            
            // Print raw response for debugging
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("Raw Response: \(rawResponse)")
            }
        }
    }.resume() // Start the data task
}

// Call the fetch function

