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
    @Published var teamQrCodeScannerViewPresented = false
    @Published var teamJoinAlertPresented = false
    @Published var teamQrCodeScanBannerPresented = false
    @Published var showingIndicator = false
    @Published var showingNewTeam = false
    @Published var inputName: String = ""
    
    private var interactor: HomeUsecase
    private var router: HomeRouter
    
    private var joinTeam: Team?
    private var beginEditingName: String = ""
    
    init(interactor: HomeUsecase, router: HomeRouter) {
        self.router = HomeRouter()
        self.teams = []
        self.interactor = interactor
        self.router = router
    }
    
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
    
    func toggleShowNewTeamSheet() -> Void {
        self.showingNewTeam.toggle()
    }
    
    func toggleShowTeamQrScannerSheet() -> Void {
        self.teamQrCodeScannerViewPresented.toggle()
    }
    
    func makeAboutNewTeamView(userId: String) -> some View {
        return router.makeNewTeamView(onCommit: self.newTeamInputCommit,
                                      onCanceled: self.toggleShowNewTeamSheet)
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
                self.teamQrCodeScannerViewPresented = false
                
                let teamQrCodeManager = TeamQrCodeManager()
                guard let teamId = teamQrCodeManager.checkMyAppQrCode(code: code) else {
                    self.showingIndicator = false
                    self.showQrCodeScanBanner()
                    return
                }
                
                self.interactor.getTeam(id: teamId) { result in
                    switch result {
                    case .success(let team):
                        self.toggleShowTeamQrScannerSheet()
                        
                        if let team = team {
                            self.joinTeam = team
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                self.teamJoinAlertPresented = true
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
            onDismiss: self.toggleShowTeamQrScannerSheet)
    }
    
    private func showQrCodeScanBanner() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.teamQrCodeScanBannerPresented = true
        }
    }
    
    func newTeamInputCommit(text: String) {
        toggleShowNewTeamSheet()
    }
    
    func teamJoinComfirm(user: User) {
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
    
    func teamJoinCancel() {
        self.joinTeam = nil
    }
    
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
}
