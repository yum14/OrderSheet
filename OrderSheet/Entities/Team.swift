//
//  Team.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import Firebase

struct Team: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var avatarImage: Data?
    var members: [String]
    var owner: String
    var createdAt: Timestamp?
    var updatedAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         name: String,
         avatarImage: Data? = nil,
         members: [String],
         owner: String,
         createdAt: Date? = nil,
         updatedAt: Date? = nil) {
        
        self.id = id
        self.name = name
        self.avatarImage = avatarImage
        self.members = members
        self.owner = owner
        self.createdAt = createdAt != nil ? Timestamp(date: createdAt!) : nil
        self.updatedAt = updatedAt != nil ? Timestamp(date: updatedAt!) : nil
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarImage = "avatar_image"
        case members = "members"
        case owner = "owner"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

