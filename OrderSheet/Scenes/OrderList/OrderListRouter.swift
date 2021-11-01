//
//  OrderListRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

final class OrderListRouter {
    
    func makeOrderDetailView(team: Team, order: Order, commitButtonTap: (() -> Void)?, editButtonTap: (() -> Void)?) -> some View {
        let interactor = OrderDetailInteractor()
        let presenter = OrderDetailPresenter(interactor: interactor, team: team, order: order, commitButtonTap: commitButtonTap, editButtonTap: editButtonTap)
        let view = OrderDetailView(presenter: presenter)
        return view
    }
    
    func makeNewOrderView(team: Team) -> some View {
        let interactor = NewOrderInteractor()
        let presenter = NewOrderPresenter(interactor: interactor, team: team)
        let view = NewOrderView(presenter: presenter)
        return view
    }
    
    func makeOrderEditView(team: Team, order: Order) -> some View {
        let interactor = OrderEditInteractor()
        let presenter = OrderEditPresenter(interactor: interactor, team: team, order: order)
        let view = OrderEditView(presenter: presenter)
        return view
    }
}
