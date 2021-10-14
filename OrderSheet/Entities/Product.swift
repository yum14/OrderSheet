//
//  Product.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import Foundation

struct Product: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    
    init(id: String = UUID().uuidString,
         name: String) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
