//
//  ResponseModels.swift
//  OrderApp
//
//  Created by Eric Davis on 29/09/2021.
//

import Foundation

struct MenuResponse: Codable {
    let items: [MenuItem]
}


struct CategoriesResponse: Codable {
    let categories: [String]
}


struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preperation_time"
    }
}



