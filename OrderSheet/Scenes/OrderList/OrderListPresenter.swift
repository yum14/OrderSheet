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
    @Published var orders: [Order] = []
    @Published var selectedOrder: Order?
    @Published var showingOrderDetail = false
    @Published var selectedTeam: Team?
    @Published var teams: [Team]?
    @Published var popupPresented = false
    @Published var showingUnlockConfirm = false
    @Published var showingNewOrder = false
    
    var unlockOrderId: String?
    
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
        self.showingOrderDetail = true
    }
    
    func showNewOrderSheet() -> Void {
        self.showingNewOrder = true
    }
    
    func makeAboutOrderDetailSheetView() -> some View {
        return router.makeOrderDetailView(team: self.selectedTeam!, order: self.selectedOrder!, commitButtonTap: { self.showingOrderDetail = false })
    }
    
    func makeAboutNewOrderSheetView() -> some View {
        return router.makeNewOrderView(team: self.selectedTeam!)
    }
    
    func updateSelectedTeam(uid: String) {
        guard let selectedTeam = self.selectedTeam else {
            return
        }
        
        self.interactor.updateSelectedTeam(id: uid, selectedTeam: selectedTeam.id) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            // OrderのListener設定
            self.setOrderListener(teamId: selectedTeam.id)
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
    
    func teamSelected(team: Team) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.popupPresented = false
        }
    }
    
    func unlockButtonTapped(id: String) {
        self.unlockOrderId = id
        self.showingUnlockConfirm = true
    }
    
    func unlock() {
        guard let orderId = self.unlockOrderId, let order = self.orders.first(where: { $0.id == orderId }), let team = self.selectedTeam else {
            return
        }

        let newOrder = Order(id: order.id,
                             name: order.name,
                             items: order.items,
                             comment: order.comment,
                             committed: false,
                             createdAt: order.createdAt.dateValue(),
                             updatedAt: Date())
        
        self.interactor.updateOrder(teamId: team.id, order: newOrder) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.unlockOrderId = nil
        }
    }
    
    func unlockCancel() {
        self.unlockOrderId = nil
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
