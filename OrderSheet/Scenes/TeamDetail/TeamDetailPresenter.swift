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
    @Published var showingLeaveTeamConfirm = false
    @Published var showingDeleteTeamConfirm = false
    
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
        self.interactor.teamLoad(id: self.id, completion: { team in
            guard let team = team else {
                self.team = nil
                return
            }

            self.team = team
            self.inputName = team.name
            
            self.interactor.memberLoad(ids: team.members) { users in
                guard let users = users else {
                    self.members = []
                    return
                }
                
                self.members = users
            }
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
                           owner: team.owner,
                           createdAt: team.createdAt.dateValue(),
                           updatedAt: Date())
        self.interactor.set(newTeam) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func onNameEditingChanged(beginEditing: Bool) {
        if beginEditing {
            self.beginEditingName = self.inputName
        }
    }
    
    func showTeamQRCodeView() -> Void {
        self.sheetPresented = true
    }
    
    func showLeaveTeamConfirmAlert() {
        self.showingLeaveTeamConfirm = true
    }
    
    func leaveTeam(user: User, completion: (() -> Void)? = {}) {
        guard let team = self.team else {
            return
        }
        
        if !team.members.contains(user.id) {
            return
        }
        
        if team.members.count <= 1 {
            self.showingDeleteTeamConfirm = true
            return
        }
        
        self.interactor.leaveMember(user: user, team: team) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            completion?()
        }
    }
    
    func leaveAndDeleteTeam(user: User, completion: (() -> Void)? = {}) {
        guard let team = self.team else {
            return
        }
        
        self.interactor.leaveMember(user: user, team: team) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            self.interactor.deleteTeamAndOrder(id: team.id) { error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                completion?()
            }
        }

    }
    
    func makeAboutTeamQRCodeView() -> some View {
        return router.makeTeamQRCodeView(teamId: self.team?.id ?? "")
    }
}
