//
//  HomeRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import SwiftUI

final class HomeRouter {
    
    func makeTeamDetailView(team: Team, members: [User]) -> some View {
        let presenter = TeamDetailPresenter(team: team, members: members)
        let view = TeamDetailView(presenter: presenter)
        return view
    }
}
