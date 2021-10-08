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
    @Published var team: Team?
    @Published var members: [User] = []
    @Published var sheetPresented = false
    @Published var inputName: String = ""
    
    private let interactor: TeamDetailUsecase
    private let router: TeamDetailRouter
    
    private var beginEditingName: String = ""
    
    private let id: String
    
    init(interactor: TeamDetailInteractor, router: TeamDetailRouter, teamId: String) {
        self.interactor = interactor
        self.router = router
        self.id = teamId
    }
    
    init(interactor: TeamDetailInteractor, router: TeamDetailRouter, team: Team, members: [User]) {
        self.interactor = interactor
        self.router = router
        self.team = team
        self.members = members
        self.inputName = team.name
        self.id = team.id
    }
    
    func load() {
        self.interactor.get(id: self.id, completion: { team in
            guard let team = team else {
                self.team = nil
                return
            }
            
            self.team = team
            self.inputName = team.name
        })
    }
    
    func onNameCommit() {
        if self.inputName.isEmpty {
            self.inputName = self.beginEditingName
            return
        }
        
        guard let team = self.team else {
            return
        }
        
        let newTeam = Team(id: team.id,
                           name: self.inputName,
                           avatarImage: team.avatarImage,
                           members: team.members,
                           createdAt: team.createdAt?.dateValue(),
                           updatedAt: Date())
        self.interactor.set(newTeam)
    }
    
    func onNameEditingChanged(beginEditing: Bool) {
        if beginEditing {
            self.beginEditingName = self.inputName
        }
    }
    
    func showTeamQRCodeView() -> Void {
        self.sheetPresented = true
    }
    
    func makeAboutTeamQRCodeView() -> some View {
        return router.makeTeamQRCodeView(teamId: self.team?.id ?? "")
    }
}
