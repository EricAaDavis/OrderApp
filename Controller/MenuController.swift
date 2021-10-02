//
//  MenuController.swift
//  OrderApp
//
//  Created by Eric Davis on 29/09/2021.
//

import Foundation
import UIKit

class MenuController {
    
    var userActivity = NSUserActivity(activityType: "com.example.OrderApp.order")
    
    static let shared = MenuController()
    
    static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
            userActivity.order = order
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
    
    func submitOrder(forMenuIDs menuIDs: [Int], completion: @escaping (Result<MinutesToPrepareInt, Error>) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        let data = ["menuIds": menuIDs]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        print(orderURL)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    
                    let jsonDecoder = JSONDecoder()
                    let orderResponse = try jsonDecoder.decode(OrderResponse.self, from: data)
                    completion(.success(orderResponse.prepTime))
                } catch {
                    print("unable to decode")
                    completion(.failure(error))
                }
            } else if let error = error {
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
    
    
    
    func updateUserActivity(with controller: StateRestorationController) {
        switch controller {
        case .categories, .order:
            break
        case .menu(let category):
            userActivity.menuCategory = category
        case .menuItemDetail(let menuItem):
            userActivity.menuItem = menuItem
        }
        userActivity.controllerIdentifier =  controller.identifier
        
    }
    
}
