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
    @Published var showingTeamQrCodeScanBanner = false
    @Published var showingIndicator = false
    @Published var showingNewTeamView = false
    @Published var inputName: String = ""
    @Published var avatarImage: UIImage?
    
    var joinTeam: Team?
    
    private var interactor: HomeUsecase
    private var router: HomeRouter
    
    private var beginEditingName: String = ""
    private var avatarInitialLoading: Bool = false
    
    init(interactor: HomeUsecase, router: HomeRouter) {
        self.router = HomeRouter()
        self.teams = []
        self.interactor = interactor
        self.router = router
    }
    
    convenience init(interactor: HomeUsecase, router: HomeRouter, teams: [Team]) {
        self.init(interactor: interactor, router: router)
        self.teams = teams
    }
}
 
extension HomePresenter {
    func addSnapshotListener() {
        self.interactor.addSnapshotListener(onListen: { teams in
            self.teams = teams
        })
    }
    
    func initialLoad(user: User) {
        self.showingIndicator = true
        self.inputName = user.displayName
        self.loadTeams(userId: user.id) {
            self.showingIndicator = false
        }
        if let avatarImage = user.avatarImage {
            self.avatarInitialLoading = true
            self.avatarImage = UIImage(data: avatarImage)
        }
    }
    
    private func loadTeams(userId: String, completion: (() -> Void)?) {
        self.interactor.loadTeams(userId: userId) { result in
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
                                router.makeTeamDetailView(id: team.id)
                                .onDisappear {
            self.showingIndicator = true
            self.loadTeams(userId: userId) {
                self.showingIndicator = false
            }
        }) {
            content()
        }
    }
    
    func makeAboutNewTeamView(userId: String) -> some View {
        return router.makeNewTeamView(onCommit: { _ in self.showingNewTeamView = false },
                                      onCanceled: { self.showingNewTeamView = false })
            .onDisappear {
                self.showingIndicator = true
                self.loadTeams(userId: userId) {
                    self.showingIndicator = false
                }
            }
    }
    
    func makeAboutTeamQrCodeScannerView(user: User) -> some View {
        
        return router.makeTeamQrCodeScannerView(
            onFound: { code2 in
                
                let code = "https://icu.yum14/ordersheet/teams/F1458B93-1136-4746-81E2-F6E617C28038"
                
                
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
                            if user.teams.contains(team.id) {
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
        if self.inputName.isEmpty {
            self.inputName = self.beginEditingName
            return
        }
        
        self.interactor.updateUserDisplayName(id: user.id, displayName: self.inputName) { error in
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
    
    func onAvatarImageChanged(user: User, image: UIImage) {
        if self.avatarInitialLoading {
            self.avatarInitialLoading = false
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 1) else {
            return
        }
        
        if let dbValue = user.avatarImage, dbValue == imageData {
            return
        }
        
        self.interactor.updateAvatarImage(id: user.id, avatarImage: imageData) { error in
            if let error = error {
                print(error.localizedDescription)
            }
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
        if let team = self.joinTeam {
            self.showingIndicator = true
            
            self.interactor.addTeam(user: user, teamId: team.id, completion: { error in
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
            })
        }
    }
    
    func onJoinTeamCancelButtonTapped() {
        self.joinTeam = nil
    }
}
