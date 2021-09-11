//
//  Order.swift
//  OrderSheet
//
//  Created by yum on 2021/09/08.
//

import Foundation

struct Order: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var items: [Product] = []
    var comment: String = ""
    var createdAt: Date = Date()
    var updatedAt: Date?
}
