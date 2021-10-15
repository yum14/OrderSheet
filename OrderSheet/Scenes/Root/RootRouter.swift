//
//  RootRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

final class RootRouter {
    let orderListPresenter: OrderListPresenter
    let loginPresener: LoginPresenter
    let homePresenter: HomePresenter
    
    init() {
        let orderListInteractor = OrderListInteractor()
        let orderListRouter = OrderListRouter()
        self.orderListPresenter = OrderListPresenter(interactor: orderListInteractor, router: orderListRouter)
        self.loginPresener = LoginPresenter()
        
        let homeInteractor = HomeInteractor()
        let homeRouter = HomeRouter()
        self.homePresenter = HomePresenter(interactor: homeInteractor, router: homeRouter)
    }
    

    func makeOrderListView() -> some View {
        let view = OrderListView(presenter: self.orderListPresenter)
        return view
    }
    
    func makeLoginView() -> some View {
        let view = LoginView(presenter: self.loginPresener)
        return view
    }
    
    func makeHomeView() -> some View {
        let view = HomeView(presenter: self.homePresenter)
        return view
    }
}
