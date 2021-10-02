//
//  MenuItem.swift
//  OrderApp
//
//  Created by Eric Davis on 29/09/2021.
//

import Foundation

struct MenuItem: Codable {
    
    var id: Int
    var name: String
    var description: String
    var price: Double
    var category: String
    var image_url: URL
    
    enum codingKeys: String, CodingKey {
        case id
        case name
        case desciption
        case price
        case category
        case image_url
    }
    
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "NOK"
        
        return formatter
    }()
    
}
