//
//  Order.swift
//  OrderSheet
//
//  Created by yum on 2021/09/08.
//

import Foundation
import Firebase

struct Order: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var items: [OrderItem]
    var comment: String?
    var createdAt: Timestamp
    var updatedAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         name: String,
         items: [OrderItem] = [],
         comment: String? = nil,
         createdAt: Date? = Date(),
         updatedAt: Date? = nil) {
        
        self.id = id
        self.name = name
        self.items = items
        self.comment = comment
        self.createdAt = createdAt != nil ? Timestamp(date: createdAt!) : Timestamp(date: Date())
        self.updatedAt = updatedAt != nil ? Timestamp(date: updatedAt!) : nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case items
        case comment
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct OrderItem: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var checked: Bool
    
    init(id: String = UUID().uuidString,
         name: String,
         checked: Bool = false) {
        self.id = id
        self.name = name
        self.checked = checked
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case checked
    }
}
