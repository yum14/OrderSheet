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
        case OrderDetail
        case NewOrder
    }
    
    @Published var orders: [Order] = []
    @Published var selectedOrder: Order?
    @Published var sheetPresented = false
    @Published var selectedTeam: Team?
    @Published var teams: [Team]?
    @Published var popupPresented = false
    var sheetType: SheetType?
    
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
    
    func showOrderDetailSheet(order: Order) -> Void {
        self.selectedOrder = order
        self.sheetType = .OrderDetail
        self.sheetPresented = true
    }
    
    func showNewOrderSheet() -> Void {
        self.selectedOrder = nil
        self.sheetType = .NewOrder
        self.sheetPresented = true
    }
    
    func makeAboutOrderDetailSheetView() -> some View {
        return router.makeOrderDetailView(team: self.selectedTeam!, order: self.selectedOrder!, commitButtonTap: { self.sheetPresented = false })
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
            self.interactor.setOrderListener(teamId: selectedTeam.id) { orders in
                self.orders = orders ?? []
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
