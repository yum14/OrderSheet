//
//  OrderListRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

protocol OrderListWireframe {
    func makeOrderDetailView(team: Team, order: Order, owner: Profile, commitButtonTap: (() -> Void)?, editButtonTap: (() -> Void)?) -> AnyView
    func makeNewOrderView(profile: Profile, team: Team) -> AnyView
    func makeOrderEditView(profile: Profile, team: Team, order: Order) -> AnyView
}

final class OrderListRouter {
    static func assembleModules() -> AnyView {
        let interactor = OrderListInteractor()
        let router = OrderListRouter()
        let presenter = OrderListPresenter(interactor: interactor, router: router)
        let view = OrderListView(presenter: presenter)
        return AnyView(view)
    }
}

extension OrderListRouter: OrderListWireframe {
    func makeOrderDetailView(team: Team, order: Order, owner: Profile, commitButtonTap: (() -> Void)?, editButtonTap: (() -> Void)?) -> AnyView {
        return OrderDetailRouter.assembleModules(team: team, order: order, owner: owner, commitButtonTap: commitButtonTap, editButtonTap: editButtonTap)
    }
    
    func makeNewOrderView(profile: Profile, team: Team) -> AnyView {
        return NewOrderRouter.assembleModules(profile: profile, team: team)
    }
    
    func makeOrderEditView(profile: Profile, team: Team, order: Order) -> AnyView {
        return OrderEditRouter.assembleModules(profile: profile, team: team, order: order)
    }
}
