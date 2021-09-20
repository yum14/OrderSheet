//
//  User.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import UIKit

struct User: Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var avotor: Data?
    var teams: [Team]
}
