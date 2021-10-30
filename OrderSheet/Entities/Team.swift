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
    var disabled: Bool
    var createdAt: Timestamp
    var updatedAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         name: String,
         avatarImage: Data? = nil,
         members: [String],
         owner: String,
         disabled: Bool = false,
         createdAt: Date? = Date(),
         updatedAt: Date? = nil) {
        
        self.id = id
        self.name = name
        self.avatarImage = avatarImage
        self.members = members
        self.owner = owner
        self.disabled = disabled
        self.createdAt = createdAt != nil ? Timestamp(date: createdAt!) : Timestamp(date: Date())
        self.updatedAt = updatedAt != nil ? Timestamp(date: updatedAt!) : nil
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case avatarImage = "avatar_image"
        case members
        case owner
        case disabled
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

