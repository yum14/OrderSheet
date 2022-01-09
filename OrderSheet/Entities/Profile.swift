//
//  Profile.swift
//  OrderSheet
//
//  Created by yum on 2022/01/07.
//

import Foundation
import Firebase

struct Profile: Identifiable, Hashable, Codable {
    var id: String
    var displayName: String
    var avatarImage: Data?
    var teams: [String]
    var selectedTeam: String?
    
    init(id: String,
         displayName: String,
         avatarImage: Data? = nil,
         teams: [String],
         selectedTeam: String? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.avatarImage = avatarImage
        self.teams = teams
        self.selectedTeam = selectedTeam
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case avatarImage = "avatar_image"
        case teams
        case selectedTeam = "selected_team"
    }
}
