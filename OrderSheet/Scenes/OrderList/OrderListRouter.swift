//
//  OrderListRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

final class OrderListRouter {
    
    func makeOrderDetailView(team: Team, order: Order, commitButtonTap: @escaping () -> Void = {}) -> some View {
        let interactor = OrderDetailInteractor()
        let presenter = OrderDetailPresenter(interactor: interactor, team: team, order: order, commitButtonTap: commitButtonTap)
        let view = OrderDetailView(presenter: presenter)
        return view
    }
    
    func makeNewOrderView(team: Team) -> some View {
        let interactor = NewOrderInteractor()
        let presenter = NewOrderPresenter(interactor: interactor, team: team)
        let view = NewOrderView(presenter: presenter)
        return view
    }
}
