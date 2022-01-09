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
    var email: String?
    var photoUrl: String?
    var notificationToken: String?
    var lastLogin: Timestamp? = Timestamp(date: Date())
    
    init(id: String = UUID().uuidString,
         email: String? = nil,
         photoUrl: String? = nil,
         notificationToken: String? = nil,
         lastLogin: Date = Date()
    ) {
        self.id = id
        self.email = email
        self.photoUrl = photoUrl
        self.notificationToken = notificationToken
        self.lastLogin = Timestamp(date: lastLogin)
    }
    
    init(id: String = UUID().uuidString,
         email: String? = nil,
         photoUrl: String? = nil,
         notificationToken: String? = nil,
         lastLogin: Timestamp?
    ) {
        self.id = id
        self.email = email
        self.photoUrl = photoUrl
        self.notificationToken = notificationToken
        self.lastLogin = lastLogin
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case photoUrl = "photo_url"
        case notificationToken = "notification_token"
        case lastLogin = "last_login"
    }
}
