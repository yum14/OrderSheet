//
//  SelectedTeam.swift
//  OrderSheet
//
//  Created by yum on 2022/01/06.
//

import Foundation
import Firebase

struct SelectedTeam: Identifiable, Hashable, Codable {
    var id: String
    var teamId: String
    var createdAt: Timestamp
    var updatedAt: Timestamp?
    
    init(id: String = UUID().uuidString,
         teamId: String,
         createdAt: Date? = Date(),
         updatedAt: Date? = nil) {
        
        self.id = id
        self.teamId = teamId
        self.createdAt = createdAt != nil ? Timestamp(date: createdAt!) : Timestamp(date: Date())
        self.updatedAt = updatedAt != nil ? Timestamp(date: updatedAt!) : nil
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case teamId
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}
