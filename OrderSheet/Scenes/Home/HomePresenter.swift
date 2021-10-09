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
    
    private var interactor: HomeUsecase
    private var router: HomeRouter
    
    init(interactor: HomeUsecase, router: HomeRouter, user: User) {
        self.router = HomeRouter()
        self.user = user
        self.teams = []
        self.interactor = interactor
        self.router = router
    }

    init(interactor: HomeUsecase, router: HomeRouter, user: User, teams: [Team]) {
        self.router = HomeRouter()
        self.user = user
        self.teams = teams
        self.interactor = interactor
        self.router = router
    }
    
    func addSnapshotListener() {
        self.interactor.addSnapshotListener(onListen: { teams in
            self.teams = teams
        })
    }
    
    func loadTeams() {
        self.interactor.loadTeams(completion: { result in
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
        })
    }
    
    func linkBuilder<Content: View>(team: Team, @ViewBuilder content: () -> Content) -> some View {
        return NavigationLink(destination:
                                router.makeTeamDetailView(id: team.id)
                                .onDisappear { self.loadTeams() }) {
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
        return router.makeNewTeamView(user: self.user,
                                      onCommit: self.newTeamInputCommit,
                                      onCanceled: self.toggleShowNewTeamSheet)
            .onDisappear {
                self.loadTeams()
            }
    }

    func makeAboutTeamQrCodeScannerView() -> some View {
        
        return router.makeTeamQrCodeScannerView(
            onFound: { code in
                // TODO: code（ID）でRealmからチームを検索する
                self.toggleShowTeamQrScannerSheet()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.teamJoinAlertPresented = true
                }
            },
            onDismiss: self.toggleShowTeamQrScannerSheet)
    }
    
    func newTeamInputCommit(text: String) {
        // TODO: 登録
//        teams.append(Team(name: text, members: []))
        toggleShowNewTeamSheet()
    }
}
