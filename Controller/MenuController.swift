//
//  MenuController.swift
//  OrderApp
//
//  Created by Eric Davis on 29/09/2021.
//

import Foundation

class MenuController {
    let baseURL = URL(string: "http://localhost8080/")!
    
    //Get request for the categories
    func fetchCategories(completion: @escaping (Result<[String], Error>) -> Void) {
        let categoriesURL = baseURL.appendingPathComponent("categories")
        
        let task = URLSession.shared.dataTask(with: categoriesURL) {
            (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
                    completion(.success(categoriesResponse.categories))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
    
    //Get request for the items within a category
    func fetchMenuItems(forCategory categoryName: String,
                        completion: @escaping (Result<[MenuItem], Error>) -> Void) {
        
        let baseMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: baseMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        print(components)
        let menuURL = components.url!
        print(menuURL)
        //remember to print the url to have a look at it to see if you can see the same things in the browser
        let task = URLSession.shared.dataTask(with: menuURL) {
            (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let menuResponse = try jsonDecoder.decode(MenuResponse.self, from: data)
                    completion(.success(menuResponse.items))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
        
    }
    
    //Post containing the user's order when it's time to communicate back to the resturaunt's server
    typealias MinutesToPrepareInt = Int
    func submitOrder(forMenuIDs menuIDs: [Int],
                     completion: @escaping (Result<MinutesToPrepareInt, Error>) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        
        //modify the request default from type get to post
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        //tell the server that the request is sending json data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) {
        (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
                    completion(.success(orderResponse.prepTime))
                } catch {
                    completion(.failure(error))
                }
            } else if let error = error {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
