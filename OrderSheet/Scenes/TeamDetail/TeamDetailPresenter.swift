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
    @Published var members: [Profile] = []
    @Published var sheetPresented = false
    @Published var inputName: String = ""
    @Published var showingLeaveTeamConfirm = false
    @Published var showingDeleteTeamConfirm = false
    @Published var avatarImage: UIImage?
    @Published var showingIndicator = false
    
    var profile: Profile
    
    private let interactor: TeamDetailUsecase
    private let router: TeamDetailWireframe
    
    private var beginEditingName: String = ""
    private var avatarInitialLoading: Bool = false
    
    init(interactor: TeamDetailInteractor, router: TeamDetailWireframe, profile: Profile, team: Team) {
        self.interactor = interactor
        self.router = router
        self.profile = profile
        self.team = team
    }
    
    convenience init(interactor: TeamDetailInteractor, router: TeamDetailWireframe, profile: Profile, team: Team, members: [Profile]) {
        self.init(interactor: interactor, router: router, profile: profile, team: team)
        self.members = members
    }
    
    func load() {
        self.showingIndicator = true
        
        self.inputName = team.name

        if let avatarImage = team.avatarImage {
            self.avatarInitialLoading = true
            self.avatarImage = UIImage(data: avatarImage)
        }
        
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
        
        self.interactor.updateTeamName(id: self.team.id, name: self.inputName) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let newProfile = Profile(id: self.profile.id, displayName: self.inputName, avatarImage: self.profile.avatarImage, teams: self.profile.teams, selectedTeam: self.profile.selectedTeam)
            
            self.profile = newProfile
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
    
    func leaveTeam(completion: (() -> Void)? = {}) {
        if !self.team.members.contains(self.profile.id) {
            return
        }
        
        if self.team.members.count <= 1 {
            self.showingDeleteTeamConfirm = true
            return
        }
        
        self.showingIndicator = true
        
        self.interactor.leaveMember(profile: self.profile, team: self.team) { error in
            if let error = error {
                print(error.localizedDescription)
                self.showingIndicator = false
                return
            }
            
            completion?()
            self.showingIndicator = false
        }
    }
    
    func leaveAndDeleteTeam(completion: (() -> Void)? = {}) {
        self.showingIndicator = true
        
        self.interactor.leaveMember(profile: self.profile, team: self.team) { error in
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
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        if let dbValue = self.team.avatarImage, dbValue == imageData {
            return
        }
        
        self.interactor.updateAvatarImage(id: self.team.id, avatarImage: imageData) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let newProfile = Profile(id: self.profile.id, displayName: self.profile.displayName, avatarImage: imageData, teams: self.profile.teams, selectedTeam: self.profile.selectedTeam)
            
            self.profile = newProfile
        }
    }
}
