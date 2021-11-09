//
//  RootRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

protocol RootWireframe {
    func makeOrderListView() -> AnyView
    func makeLoginView() -> AnyView
    func makeHomeView() -> AnyView
}

final class RootRouter {
//    let orderListPresenter: OrderListPresenter
//    let loginPresener: LoginPresenter
//    let homePresenter: HomePresenter
    
    init() {
//        let orderListInteractor = OrderListInteractor()
//        let orderListRouter = OrderListRouter()
//        self.orderListPresenter = OrderListPresenter(interactor: orderListInteractor, router: orderListRouter)
//        self.loginPresener = LoginPresenter()
//
//        let homeInteractor = HomeInteractor()
//        let homeRouter = HomeRouter()
//        self.homePresenter = HomePresenter(interactor: homeInteractor, router: homeRouter)
    }
    
    static func assembleModules() -> AnyView {
        let router = RootRouter()
        let presenter = RootPresenter(router: router)
        let view = RootView(presenter: presenter)
        return AnyView(view)
    }

}

extension RootRouter: RootWireframe {
    
    func makeOrderListView() -> AnyView {
        return OrderListRouter.assembleModules()
    }
    
    func makeLoginView() -> AnyView {
        return LoginRouter.assembleModules()
    }
    
    func makeHomeView() -> AnyView {
        return HomeRouter.assembleModules()
    }
}
