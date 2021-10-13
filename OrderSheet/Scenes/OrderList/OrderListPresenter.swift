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
    @Published var sheetPresented = false
    @Published var selectedTeam: Team?
    
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
    
    func showOrderSheet(order: Order) -> Void {
        self.selectedOrder = order
        self.sheetPresented.toggle()
    }
    
    func makeAboutOrderDetailView() -> some View {
        return router.makeOrderDetailView(order: self.selectedOrder!, commitButtonTap: { self.sheetPresented.toggle() })
    }
    
    func linkBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeNewOrderView()) {
            content()
        }
    }
    
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
