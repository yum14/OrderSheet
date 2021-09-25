//
//  HomePresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import SwiftUI
import Combine

final class HomePresenter: ObservableObject {
    @Published var user: User
    @Published var teams: [Team]
    @Published var newTeamViewPresented = false
    @Published var teamQrCodeScannerViewPresented = false
    @Published var teamJoinAlertPresented = false
    private let router = HomeRouter()
    
    init(user: User, teams: [Team]) {
        self.user = user
        self.teams = teams
    }
    
    func linkBuilder<Content: View>(team: Team, @ViewBuilder content: () -> Content) -> some View {
        
        // TODO: ここでDBからmemberを取得することになると思う
        let members = [User(name: "メンバー1", teams: []), User(name: "メンバー2", teams: [])]
        
        return NavigationLink(destination: router.makeTeamDetailView(team: team, members: members)) {
            content()
        }
    }
    
    func toggleShowNewTeamSheet() -> Void {
        self.newTeamViewPresented.toggle()
    }

    func toggleShowTeamQrScannerSheet() -> Void {
        self.teamQrCodeScannerViewPresented.toggle()
    }
    
    func makeAboutNewTeamView() -> some View {
        let presenter = NewTeamPresenter(onCommit: self.newTeamInputCommit, onCanceled: self.toggleShowNewTeamSheet)
        return NewTeamView(presenter: presenter)
    }

    func makeAboutTeamQrCodeScannerView() -> some View {
        let presenter = TeamQrCodeScannerPresenter(
            onFound: { code in
                // TODO: code（ID）でRealmからチームを検索する
                self.toggleShowTeamQrScannerSheet()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.teamJoinAlertPresented = true
                }
            },
            onDismiss: {
                self.toggleShowTeamQrScannerSheet()
                
            })
        return TeamQrCodeScannerView(presenter: presenter)
    }
    
    func newTeamInputCommit(text: String) {
        // TODO: 登録
        teams.append(Team(name: text, members: []))
        toggleShowNewTeamSheet()
    }
}
