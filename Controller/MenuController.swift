//
//  MenuController.swift
//  OrderApp
//
//  Created by Eric Davis on 29/09/2021.
//

import Foundation
import UIKit

class MenuController {
    
    static let shared = MenuController()
    
    static let orderUpdateNotification = Notification.Name("MenuController.orderUpdated")
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdateNotification, object: nil)
        }
    }
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    //Get request for the categories
    func fetchCategories(completion: @escaping (Result<[String], Error>) -> Void) {
        
        let categoriesStringURL = "\(baseURL)categories"
        let categoriesURL = URL(string: categoriesStringURL)!
        let task = URLSession.shared.dataTask(with: categoriesURL) {
            (data, response, error) in
            if let data = data {
                print("this is the data \(data)")
                do {
                    let jsonDecoder = JSONDecoder()
                    let categoriesResponse = try jsonDecoder.decode(CategoriesResponse.self, from: data)
                    completion(.success(categoriesResponse.categories))
                } catch {
//                    print("it is this at which is running")
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
        
        
        let fetchMenuItemsString = "\(baseURL)menu?category=\(categoryName)"
        let fetchMenuItemsURL = URL(string: fetchMenuItemsString)!
//        var components = URLComponents(url: fetchMenyItemsURL, resolvingAgainstBaseURL: true)!
//        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        print(fetchMenuItemsURL)
        let task = URLSession.shared.dataTask(with: fetchMenuItemsURL) {
            (data, response, error) in
            if let data = data {
                print(data)
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
        let orderStringURL = "\(baseURL)order"
        let orderURL = URL(string: orderStringURL)!

        //modify the request default from type get to post
        var request = URLRequest(url: orderURL)
        request.httpMethod = "POST"
        //tell the server that the request is sending json data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let data = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        print(data)
        print("this is the json data \(jsonData!)")
        print(request)

        let task = URLSession.shared.dataTask(with: request) {
        (data, response, error) in
            if let data = data {
                do {
                    let jsonDecoder = JSONDecoder()
                    print("step 1 worked")
                    let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
                    print("Step 2 worked")
                    completion(.success(orderResponse.preperation_time))
                    print("Step 3 Worked")
                } catch {
                    print("we are unable to decode")
                    completion(.failure(error))
                }
            } else if let error = error {
                print("Something is wrong with the json post url")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if let data = data,
               let image = UIImage(data: data) {
                print("This is the \(image)")
                completion(image)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }

//    func submitOrder(forMenuIDs menuIDs: [Int], completion:
//       @escaping (Result<MinutesToPrepare, Error>) -> Void) {
//        let orderURL = baseURL.appendingPathComponent("order")
//        var request = URLRequest(url: orderURL)
//        request.httpMethod = "POST"
//        request.setValue("application/json",
//           forHTTPHeaderField: "Content-Type")
//
//        let data = ["menuIds": menuIDs]
//        let jsonEncoder = JSONEncoder()
//        let jsonData = try? jsonEncoder.encode(data)
//        request.httpBody = jsonData
//
//        let task = URLSession.shared.dataTask(with: request)
//           { (data, response, error) in
//
//        }
//        task.resume()
//    }

    
}
