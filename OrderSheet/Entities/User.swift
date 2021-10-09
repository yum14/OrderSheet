//
//  User.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import Firebase

struct User: Identifiable, Hashable, Codable {
    var id: String = UUID().uuidString
    var displayName: String
    var email: String?
    var photoUrl: String?
    var avatarImage: Data?
    var teams: [String]
    var lastLogin: Timestamp? = Timestamp(date: Date())
    
    init(id: String = UUID().uuidString,
         displayName: String,
         email: String? = nil,
         photoUrl: String? = nil,
         avatarImage: Data? = nil,
         teams: [String],
         lastLogin: Date = Date()
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.photoUrl = photoUrl
        self.avatarImage = avatarImage
        self.teams = teams
        self.lastLogin = Timestamp(date: lastLogin)
    }
    
    init(id: String = UUID().uuidString,
         displayName: String,
         email: String? = nil,
         photoUrl: String? = nil,
         avatarImage: Data? = nil,
         teams: [String],
         lastLogin: Timestamp?
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.photoUrl = photoUrl
        self.avatarImage = avatarImage
        self.teams = teams
        self.lastLogin = lastLogin
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case email
        case photoUrl = "photo_url"
        case avatarImage = "avatar_image"
        case teams
        case lastLogin = "last_login"
    }
}
