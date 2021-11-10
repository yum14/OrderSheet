//
//  OrderListRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

protocol OrderListWireframe {
    func makeOrderDetailView(team: Team, order: Order, owner: User, commitButtonTap: (() -> Void)?, editButtonTap: (() -> Void)?) -> AnyView
    func makeNewOrderView(team: Team) -> AnyView
    func makeOrderEditView(team: Team, order: Order) -> AnyView
}

final class OrderListRouter {
    
    static let interactor = OrderListInteractor()
    static let router = OrderListRouter()
    static let presenter = OrderListPresenter(interactor: interactor, router: router)
    
    static func assembleModules() -> AnyView {
        let view = OrderListView(presenter: presenter)
        return AnyView(view)
    }
}

extension OrderListRouter: OrderListWireframe {
    func makeOrderDetailView(team: Team, order: Order, owner: User, commitButtonTap: (() -> Void)?, editButtonTap: (() -> Void)?) -> AnyView {
        return OrderDetailRouter.assembleModules(team: team, order: order, owner: owner, commitButtonTap: commitButtonTap, editButtonTap: editButtonTap)
    }
    
    func makeNewOrderView(team: Team) -> AnyView {
        return NewOrderRouter.assembleModules(team: team)
    }
    
    func makeOrderEditView(team: Team, order: Order) -> AnyView {
        return OrderEditRouter.assembleModules(team: team, order: order)
    }
}
