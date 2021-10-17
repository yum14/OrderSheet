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
    @Published var newTeamViewPresented = false
    @Published var teamQrCodeScannerViewPresented = false
    @Published var teamJoinAlertPresented = false
    @Published var teamQrCodeScanBannerPresented = false
    
    private var interactor: HomeUsecase
    private var router: HomeRouter
    
    private var joinTeam: Team?
    
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
    
    func loadTeams(userId: String) {
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
        }
    }
    
    func linkBuilder<Content: View>(userId: String, team: Team, @ViewBuilder content: () -> Content) -> some View {
        return NavigationLink(destination:
                                router.makeTeamDetailView(id: team.id)
                                .onDisappear { self.loadTeams(userId: userId) }) {
            content()
        }
    }
    
    func toggleShowNewTeamSheet() -> Void {
        self.newTeamViewPresented.toggle()
    }

    func toggleShowTeamQrScannerSheet() -> Void {
        self.teamQrCodeScannerViewPresented.toggle()
    }
    
    func makeAboutNewTeamView(userId: String) -> some View {
        return router.makeNewTeamView(onCommit: self.newTeamInputCommit,
                                      onCanceled: self.toggleShowNewTeamSheet)
            .onDisappear {
                self.loadTeams(userId: userId)
            }
    }

    func makeAboutTeamQrCodeScannerView() -> some View {
        
        return router.makeTeamQrCodeScannerView(
            onFound: { code in
                self.teamQrCodeScannerViewPresented = false

                let teamQrCodeManager = TeamQrCodeManager()
                guard let teamId = teamQrCodeManager.checkMyAppQrCode(code: code) else {
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
        // TODO: 登録
//        teams.append(Team(name: text, members: []))
        toggleShowNewTeamSheet()
    }
    
    func teamJoinComfirm(user: User) {
        if let team = self.joinTeam {
            self.interactor.addTeam(user: user, teamId: team.id, completion: { result in
                switch result {
                case .success():
                    self.loadTeams(userId: user.id)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self.joinTeam = nil
            })
        }
    }
    
    func teamJoinCancel() {
        self.joinTeam = nil
    }
    
    func getSafeAreaTop() -> CGFloat{
            let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first

        
        print("****** \(keyWindow?.safeAreaInsets.top) ****** ")
        
            return (keyWindow?.safeAreaInsets.top)!
        }
}
