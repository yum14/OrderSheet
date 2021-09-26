//
//  OrderListRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

final class OrderListRouter {
    
    func makeOrderDetailView(order: Order, commitButtonTap: @escaping () -> Void = {}) -> some View {
        let presenter = OrderDetailPresenter(order: order, commitButtonTap: commitButtonTap)
        let view = OrderDetailView(presenter: presenter)
        return view
    }
    
    func makeNewOrderView() -> some View {
        let presenter = NewOrderPresenter()
        let view = NewOrderView(presenter: presenter)
        return view
    }
}
