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
    @Published var members: [User] = []
    @Published var sheetPresented = false
    @Published var inputName: String = ""
    @Published var showingLeaveTeamConfirm = false
    @Published var showingDeleteTeamConfirm = false
    @Published var avatarImage: UIImage?
    @Published var showingIndicator = false
    
    private let interactor: TeamDetailUsecase
    private let router: TeamDetailWireframe
    
    private var beginEditingName: String = ""
    private var avatarInitialLoading: Bool = false
    
    init(interactor: TeamDetailInteractor, router: TeamDetailWireframe, team: Team) {
        self.interactor = interactor
        self.router = router
        self.team = team
        self.inputName = team.name

        if let avatarImage = team.avatarImage {
            self.avatarInitialLoading = true
            self.avatarImage = UIImage(data: avatarImage)
        }
    }
    
    convenience init(interactor: TeamDetailInteractor, router: TeamDetailWireframe, team: Team, members: [User]) {
        self.init(interactor: interactor, router: router, team: team)
        self.members = members
    }
    
    func load() {
        self.showingIndicator = true
        self.interactor.memberLoad(ids: self.team.members) { users in
            guard let users = users else {
                self.members = []
                self.showingIndicator = false
                return
            }
            
            self.members = users
            self.showingIndicator = false
        }
    }
    
    func onNameCommit() {
        if self.inputName.isEmpty {
            self.inputName = self.beginEditingName
            return
        }
        
        let newTeam = Team(id: self.team.id,
                           name: self.inputName,
                           avatarImage: self.team.avatarImage,
                           members: self.team.members,
                           owner: self.team.owner,
                           createdAt: self.team.createdAt.dateValue(),
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
        if !self.team.members.contains(user.id) {
            return
        }
        
        if self.team.members.count <= 1 {
            self.showingDeleteTeamConfirm = true
            return
        }
        
        self.showingIndicator = true
        
        self.interactor.leaveMember(user: user, team: self.team) { error in
            if let error = error {
                print(error.localizedDescription)
                self.showingIndicator = false
                return
            }
            
            completion?()
            self.showingIndicator = false
        }
    }
    
    func leaveAndDeleteTeam(user: User, completion: (() -> Void)? = {}) {
        self.showingIndicator = true
        
        self.interactor.leaveMember(user: user, team: self.team) { error in
            if let error = error {
                print(error.localizedDescription)
                self.showingIndicator = false
                return
            }
            
            self.interactor.deleteTeamAndOrder(id: self.team.id) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.showingIndicator = false
                    return
                }
                
                completion?()
                self.showingIndicator = false
            }
        }

    }
    
    func makeAboutTeamQRCodeView() -> some View {
        return router.makeTeamQrCodeView(teamId: self.team.id)
    }
    
    func onAvatarImageChanged(image: UIImage) {
        if self.avatarInitialLoading {
            self.avatarInitialLoading = false
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        if let dbValue = self.team.avatarImage, dbValue == imageData {
            return
        }
        
        self.interactor.updateAvatarImage(id: self.team.id, avatarImage: imageData) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
