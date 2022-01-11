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
    @Published var teams: [Team]
    @Published var showingTeamQrCodeScannerView = false
    @Published var showingJoinTeamAlert = false
    @Published var showingJoinTeamCancelAlert = false
    @Published var showingLogoutAlert = false
    @Published var showingTeamQrCodeScanBanner = false
    @Published var showingIndicator = false
    @Published var showingNewTeamView = false
    @Published var inputName: String = ""
    @Published var avatarImage: UIImage?
    
    var joinTeam: Team?
    var profile: Profile? {
        didSet {
            self.inputName = profile?.displayName ?? ""

            if let avatarImage = profile?.avatarImage {
                self.avatarImage = UIImage(data: avatarImage)
            }
        }
    }
    
    private var interactor: HomeUsecase
    private var router: HomeWireframe
    private var beginEditingName: String = ""
    private var avatarInitialLoading: Bool = false
    
    init(interactor: HomeUsecase, router: HomeWireframe) {
        self.teams = []
        self.interactor = interactor
        self.router = router
    }
    
    convenience init(interactor: HomeUsecase, router: HomeWireframe, teams: [Team], profile: Profile) {
        self.init(interactor: interactor, router: router)
        self.teams = teams
        self.profile = profile
    }
}

extension HomePresenter {
    func initialLoad(userId: String) {
        self.showingIndicator = true
        self.avatarInitialLoading = true
        
        self.interactor.getProfile(id: userId) { result in
            switch result {
            case .success(let profile):
                guard let profile = profile else {
                    return
                }
                
                self.profile = profile
                
                self.loadTeams(userId: userId) {
                    self.showingIndicator = false
                }
                
            case .failure(let error):
                print(error.localizedDescription)
                return
            }
        }
    }
    
    private func loadTeams(userId: String, completion: (() -> Void)?) {
        self.interactor.getTeams(userId: userId) { result in
            switch result {
            case .success(let teams):
                if let teams = teams {
                    self.teams = teams
                } else {
                    self.teams = []
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            completion?()
        }
    }
    
    func linkBuilder<Content: View>(userId: String, team: Team, @ViewBuilder content: () -> Content) -> some View {
        return NavigationLink(destination:
                                router.makeTeamDetailView(profile: self.profile!, team: team)) {
            content()
        }
    }
    
    func makeAboutNewTeamView(userId: String) -> some View {
        return router.makeNewTeamView(profile: self.profile!,
                                      onCommit: { _ in self.showingNewTeamView = false },
                                      onCanceled: { self.showingNewTeamView = false })
            .onDisappear {
                self.showingIndicator = true
                self.loadTeams(userId: userId) {
                    self.showingIndicator = false
                }
            }
    }
    
    func makeAboutTeamQrCodeScannerView() -> some View {
        
        return router.makeTeamQrCodeScannerView(
            onFound: { code in
                
                self.showingIndicator = true
                self.showingTeamQrCodeScannerView = false
                
                let teamQrCodeManager = TeamQrCodeManager()
                guard let teamId = teamQrCodeManager.checkMyAppQrCode(code: code) else {
                    self.showingIndicator = false
                    self.showQrCodeScanBanner()
                    return
                }
                
                self.interactor.getTeam(id: teamId) { result in
                    switch result {
                    case .success(let team):
                        self.showingTeamQrCodeScannerView = false
                        
                        if let team = team {
                            
                            // すでに参加済のチームの場合
                            if self.profile!.teams.contains(team.id) {
                                self.joinTeam = team
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.showingJoinTeamCancelAlert = true
                                }
                            } else {
                                self.joinTeam = team
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    self.showingJoinTeamAlert = true
                                }
                            }
                        } else {
                            self.showQrCodeScanBanner()
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                        self.showQrCodeScanBanner()
                    }
                    
                    self.showingIndicator = false
                }
            },
            onDismiss: { self.showingTeamQrCodeScannerView = false })
    }
    
    private func showQrCodeScanBanner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.showingTeamQrCodeScanBanner = true
        }
    }
}

extension HomePresenter {
    func onNameCommit(user: User) {
        guard let profile = self.profile else {
            return
        }
        
        
        if self.inputName.isEmpty {
            self.inputName = self.beginEditingName
            return
        }
        
        self.interactor.updateUserDisplayName(id: user.id, displayName: self.inputName) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let newProfile = Profile(id: profile.id, displayName: self.inputName, avatarImage: profile.avatarImage, teams: profile.teams, selectedTeam: profile.selectedTeam)
            
            self.profile = newProfile
        }
    }
    
    func onNameEditingChanged(beginEditing: Bool) {
        if beginEditing {
            self.beginEditingName = self.inputName
        }
    }
    
    func onAvatarImageChanged(image: UIImage) {
        guard let profile = self.profile else {
            return
        }
        
        if self.avatarInitialLoading {
            self.avatarInitialLoading = false
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
            return
        }
        
        if let dbValue = self.profile!.avatarImage, dbValue == imageData {
            return
        }
        
        self.interactor.updateAvatarImage(id: profile.id, avatarImage: imageData) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let newProfile = Profile(id: profile.id, displayName: profile.displayName, avatarImage: imageData, teams: profile.teams, selectedTeam: profile.selectedTeam)
            
            self.profile = newProfile
        }
    }
}

extension HomePresenter {
    
    func onCreateTeamButtonTapped() {
        self.showingNewTeamView = true
    }
    
    func onJoinTeamButtonTapped() {
        self.showingTeamQrCodeScannerView = true
    }
    
    func onJoinTeamAgreementButtonTapped(user: User) {
        if let team = self.joinTeam, let profile = self.profile {
            self.showingIndicator = true
            self.interactor.addTeam(profile: profile, teamId: team.id) { error in
                if let error = error {
                    print(error.localizedDescription)
                    self.showingIndicator = false
                    self.joinTeam = nil
                    return
                }
                
                self.loadTeams(userId: user.id) {
                    self.showingIndicator = false
                }
                self.joinTeam = nil
            }
        }
    }
    
    func onJoinTeamCancelButtonTapped() {
        self.joinTeam = nil
    }
}
