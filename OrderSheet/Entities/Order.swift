//
//  Order.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import Foundation

struct Order: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String = ""
}
