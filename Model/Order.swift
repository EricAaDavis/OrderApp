//
//  Order.swift
//  OrderApp
//
//  Created by Eric Davis on 29/09/2021.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
