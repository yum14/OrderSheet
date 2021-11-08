//
//  OrderListPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import Foundation
import SwiftUI
import Combine

final class OrderListPresenter: ObservableObject {
    enum SheetType {
        case detail
        case edit
    }
    
    @Published var orders: [Order] = []
    @Published var selectedOrder: Order?
    @Published var showingOrderDetailOrEdit = false
    @Published var selectedTeam: Team?
    @Published var teams: [Team]?
    @Published var showingTeamSelectPopup = false
    @Published var showingNewOrder = false
    @Published var showingOrderEdit = false
    @Published var sheetType: SheetType = .detail
    
    private let interactor: OrderListUsecase
    private let router: OrderListRouter
    
    init(interactor: OrderListUsecase, router: OrderListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    init(interactor: OrderListUsecase, router: OrderListRouter, orders: [Order] = [], teams: [Team] = []) {
        self.interactor = interactor
        self.router = router
        self.orders = orders
        self.teams = teams
    }
    
    func showOrderDetailSheet(id: String) -> Void {
        guard let showingOrder = self.orders.first(where: { $0.id == id }) else {
            return
        }
        
        self.selectedOrder = showingOrder
        self.sheetType = .detail
        self.showingOrderDetailOrEdit = true
    }
    
    func showNewOrderSheet() -> Void {
        self.showingNewOrder = true
    }
    
    func makeAboutOrderDetailSheetView() -> some View {
        return router.makeOrderDetailView(team: self.selectedTeam!,
                                          order: self.selectedOrder!,
                                          commitButtonTap: { self.showingOrderDetailOrEdit = false },
                                          editButtonTap: self.showOrderEdit)
    }
    
    private func showOrderEdit() {
        self.showingOrderDetailOrEdit = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.sheetType = .edit
            self.showingOrderDetailOrEdit = true
        }
    }
    
    func makeAboutNewOrderSheetView() -> some View {
        return router.makeNewOrderView(team: self.selectedTeam!)
    }

    func makeAboutOrderEditSheetView() -> some View {
        return router.makeOrderEditView(team: self.selectedTeam!, order: self.selectedOrder!)
            .onDisappear {
                self.sheetType = .detail
            }
    }

    func load(user: User) {
        if user.selectedTeam == nil && user.teams.count == 0 {
            return
        }
        
        if let userSelectedTeamId = user.selectedTeam, let mySelectedTeam = self.selectedTeam {
            
            if user.teams.contains(userSelectedTeamId) {
                // 変更がない場合は終了
                if userSelectedTeamId == mySelectedTeam.id {
                    return
                }
            }
        }
        
        self.interactor.loadTeams(userId: user.id) { teams in
            
            self.teams = teams
            
            var team: Team?
            if let selectedTeamId = user.selectedTeam {
                team = teams?.first(where: { $0.id == selectedTeamId })
                
                // ユーザ情報の選択チームが存在しない場合、最初のチームを選択チームとする
                if team == nil, let firstTeam = teams?.first {
                    self.updateSelectedUser(user: user, selectedTeamId: firstTeam.id)
                    team = firstTeam
                }
            } else {
                team = teams?.first
                if let firstTeam = team {
                    self.updateSelectedUser(user: user, selectedTeamId: firstTeam.id)
                }
            }
            
            self.selectedTeam = team

            guard let selectedTeam = team else {
                return
            }
            
            // OrderのListener設定
            self.setOrderListener(teamId: selectedTeam.id)
        }
    }
    
    func teamSelected(user: User, team: Team) {
                
        self.interactor.updateSelectedTeam(id: user.id, selectedTeam: team.id) { error in
            if let error = error {
                print(error.localizedDescription)
            }

            // OrderのListener設定
            self.setOrderListener(teamId: team.id)
        }
        
        self.showingTeamSelectPopup = false
    }
    
    func orderEditLinkBuilder<Content: View>(isActive: Binding<Bool>, @ViewBuilder content: () -> Content) -> some View {

        guard let team = self.selectedTeam, let order = self.selectedOrder else {
            return AnyView(EmptyView())
        }
        
        return AnyView(NavigationLink(isActive: isActive) {
            router.makeOrderEditView(team: team, order: order)
        } label: {
            content()
        })
    }
    
    private func setOrderListener(teamId: String) {
        self.interactor.setOrderListener(teamId: teamId) { orders in
            self.orders = orders ?? []
            
            if let selectedOrder = self.selectedOrder {
                // 再読込がはしったときは選択済み注文を更新する
                self.selectedOrder = self.orders.first(where: { $0.id == selectedOrder.id })
            }
            
            if self.selectedOrder == nil {
                // 初期表示時はとりあえず最初の１件の注文を選択済としておく
                let defaultOrder = self.orders.sorted(by: { $0.createdAt.dateValue() > $1.createdAt.dateValue() }).first
                self.selectedOrder = defaultOrder
            }
        }
    }

    
    private func updateSelectedUser(user: User, selectedTeamId: String) {
        // はじめての使用の場合は選択チームが存在しないので、最初のチームを選択チームに更新する
        let newUser = User(id: user.id,
                           displayName: user.displayName,
                           email: user.email,
                           photoUrl: user.photoUrl,
                           avatarImage: user.avatarImage,
                           teams: user.teams,
                           selectedTeam: selectedTeamId,
                           lastLogin: user.lastLogin)
        
        self.interactor.setUser(newUser) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
        }
    }
}
