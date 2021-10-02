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
    let preperation_time: Int
    
//    enum CodingKeys: String, CodingKey {
//        case preperation_time
//    }
}



