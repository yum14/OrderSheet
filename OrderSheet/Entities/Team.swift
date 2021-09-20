//
//  Team.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation

struct Team: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
}
