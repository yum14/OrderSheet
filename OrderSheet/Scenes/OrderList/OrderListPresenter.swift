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
        return router.makeOrderDetailView(order: self.selectedOrder!, commitButtonTap: { self.sheetPresented = false })
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
        guard let teamId = user.selectedTeam ?? user.teams.first else {
            return
        }
        
        // 変更がない場合は終了
        if user.selectedTeam != nil && self.selectedTeam != nil && user.selectedTeam! == self.selectedTeam!.id {
            return
        }
        
        self.interactor.loadTeams(userId: user.id) { teams in
            
            self.teams = teams
            
            let currentTeam = teams?.first(where: { $0.id == teamId })
            self.selectedTeam = currentTeam
            
            // OrderのListener設定
            self.interactor.setOrderListener(teamId: teamId) { orders in
                self.orders = orders ?? []
            }
            
            if user.selectedTeam != nil {
                return
            }
            
            // はじめての使用の場合は選択チームが存在しないので、最初のチームを選択チームに更新する
            let newUser = User(id: user.id,
                               displayName: user.displayName,
                               email: user.email,
                               photoUrl: user.photoUrl,
                               avatarImage: user.avatarImage,
                               teams: user.teams,
                               selectedTeam: teamId,
                               lastLogin: user.lastLogin)
            
            self.interactor.setUser(newUser) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
