//
//  Notification.swift
//  OrderSheet
//
//  Created by yum on 2021/12/11.
//

import Foundation
import Firebase

struct Notification: Identifiable, Hashable, Codable {
    var id: String
    var userId: String
    var title: String
    var body: String
    var icon: String
    var members: [String]
    var createdAt: Timestamp
    var updatedAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         userId: String,
         title: String,
         body: String,
         icon: String = "",
         members: [String],
         createdAt: Date? = Date(),
         updatedAt: Date? = nil) {
        
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
        self.icon = icon
        self.members = members
        self.createdAt = createdAt != nil ? Timestamp(date: createdAt!) : Timestamp(date: Date())
        self.updatedAt = updatedAt != nil ? Timestamp(date: updatedAt!) : nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case title
        case body
        case icon
        case members = "member_ids"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
