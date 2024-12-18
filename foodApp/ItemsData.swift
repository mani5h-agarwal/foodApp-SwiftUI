//
//  ItemsDats.swift
//  foodApp
//
//  Created by Manish Agarwal on 17/12/24.
//

import Foundation

// Define the model based on your JSON structure
struct Item: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
    let protein: Int
    let calories: Int
    let imageURL: String
    let price: Double
    let carbs: Int
}

func fetchItemsData(completion: @escaping ([Item]) -> Void) {
    let urlString = "http://localhost:8001/api/itemsData"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        guard let data = data else {
            print("No data received")
            return
        }
        
        do {
            let items = try JSONDecoder().decode([Item].self, from: data)
            DispatchQueue.main.async {
                completion(items)
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
        }
    }.resume()
}


func fetchItem(byId id: Int, completion: @escaping (Item?) -> Void) {
    let urlString = "http://localhost:8001/api/itemsData?id=\(id)"
    
    guard let url = URL(string: urlString) else {
        print("Invalid URL")
        completion(nil)
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            completion(nil)
            return
        }
        
        guard let data = data else {
            print("No data received")
            completion(nil)
            return
        }
        
        do {
            let item = try JSONDecoder().decode(Item.self, from: data)
            DispatchQueue.main.async {
                completion(item)
            }
        } catch {
            print("Error decoding JSON: \(error.localizedDescription)")
            completion(nil)
        }
    }.resume()
}
