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
    @Published var sheetType: SheetType = .detail
    
    var toolbarItemDisabled: Bool {
        self.showingTeamSelectPopup
    }
    
    private var orderIdAndOwners: [String:User] = [:]
    private let interactor: OrderListUsecase
    private let router: OrderListWireframe
    private var selectedTeamByUser: SelectedTeam?
    
    init(interactor: OrderListUsecase, router: OrderListWireframe) {
        self.interactor = interactor
        self.router = router
    }
    
    convenience init(interactor: OrderListUsecase, router: OrderListWireframe, orders: [Order] = [], teams: [Team] = []) {
        self.init(interactor: interactor, router: router)
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
                                          owner: self.orderIdAndOwners[self.selectedOrder!.id]!,
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
        if self.selectedTeamByUser == nil && user.teams.count == 0 {
            return
        }
        
        if let selectedTeamByUser = self.selectedTeamByUser, let mySelectedTeam = self.selectedTeam {
            if user.teams.contains(selectedTeamByUser.teamId) {
                // 変更がない場合は終了
                if selectedTeamByUser.teamId == mySelectedTeam.id {
                    return
                }
            }
        }
        
        
        self.interactor.loadSelectedTeam(userId: user.id) { selectedTeam in
            self.interactor.loadTeams(userId: user.id) { teams in
                
                self.teams = teams
                
                var team: Team?
                if let selectedTeam = selectedTeam {
                    team = teams?.first(where: { $0.id == selectedTeam.id })
                    
                    // ユーザ情報の選択チームが存在しない場合、最初のチームを選択チームとする
                    if team == nil, let firstTeam = teams?.first {
                        let newValue = SelectedTeam(teamId: firstTeam.id)
                        self.interactor.setSelectedTeam(userId: user.id, newValue) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                        team = firstTeam
                    }
                } else {
                    team = teams?.first
                    if let firstTeam = team {
                        let newValue = SelectedTeam(teamId: firstTeam.id)
                        self.interactor.setSelectedTeam(userId: user.id, newValue) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
                
                self.selectedTeam = team
                self.selectedTeamByUser = selectedTeam
                
                guard let selectedTeam = team else {
                    return
                }
                
                // OrderのListener設定
                self.setOrderListener(teamId: selectedTeam.id)
            }
        }
        
        
    }
    
    func teamSelected(user: User, team: Team) {

        let newValue = SelectedTeam(teamId: team.id)
        self.interactor.setSelectedTeam(userId: user.id, newValue) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            // OrderのListener設定
            self.setOrderListener(teamId: team.id)
            self.selectedTeamByUser = newValue
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
            
            if let orders = orders, orders.count > 0 {
                let owners = Array(Set(orders.map { $0.owner }))
                
                // オーダーの作成者名を取得
                self.interactor.getUser(ids: owners) { result in
                    switch result {
                    case .success(let users):
                        if let users = users {
                            var orderIdAndOwners: [String:User] = [:]
                            for order in orders {
                                if let user = users.first(where: { $0.id == order.owner }) {
                                    orderIdAndOwners[order.id] = user
                                }
                            }
                            
                            self.orderIdAndOwners = orderIdAndOwners
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
            
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

    
//    private func updateSelectedUser(id: String, userId: String, teamId: String) {
//        self.interactor.updateSelectedTeam(id: id, userId: userId, teamId: teamId) { error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//        }
//    }
//
//    private func createSelectedUser(userId: String, teamId: String) {
//        self.interactor.createSelectedTeam(userId: userId, teamId: teamId) { error in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//        }
//    }
}
