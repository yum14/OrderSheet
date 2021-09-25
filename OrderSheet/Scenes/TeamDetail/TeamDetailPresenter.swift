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
    @Published var sheetPresented = false
    
    init(team: Team, members: [User]) {
        self.team = team
        self.members = members
    }
    
    func showTeamQRCodeView() -> Void {
        self.sheetPresented = true
    }
    
    func makeAboutTeamQRCodeView() -> some View {
        let presenter = TeamQrCodePresenter(teamId: team.id)
        return TeamQrCodeView(presenter: presenter)
    }
}
