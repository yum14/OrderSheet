//
//  TeamDetailPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import SwiftUI
import Combine

final class TeamDetailPresenter: ObservableObject {
    @Published var team: Team
    @Published var members: [User]
    
    init(team: Team, members: [User]) {
        self.team = team
        self.members = members
    }
}
