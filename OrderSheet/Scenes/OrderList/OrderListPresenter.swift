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
    var sheetType: SheetType?
    
    private let interactor: OrderListUsecase
    private let router: OrderListRouter
    
    init(interactor: OrderListUsecase, router: OrderListRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    init(interactor: OrderListUsecase, router: OrderListRouter, orders: [Order]) {
        self.interactor = interactor
        self.router = router
        self.orders = orders
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
    
//    func linkBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
//        NavigationLink(destination: router.makeNewOrderView()) {
//            content()
//        }
//    }
    
    func load(user: User) {
        // 1番最初の選択チームはなんでもよし
        guard let teamId = user.selectedTeam ?? user.teams.first else {
            return
        }
        
        self.interactor.loadCurrentTeam(id: teamId) { team in
            self.selectedTeam = team
            
            guard let team = team else {
                return
            }
            
            if user.selectedTeam != nil {
                return
            }
            
            let newUser = User(id: user.id,
                               displayName: user.displayName,
                               email: user.email,
                               photoUrl: user.photoUrl,
                               avatarImage: user.avatarImage,
                               teams: user.teams,
                               selectedTeam: team.id,
                               lastLogin: user.lastLogin)
            
            self.interactor.setUser(newUser) { error in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
}
