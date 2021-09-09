//
//  OrdersViewPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import Foundation
import SwiftUI
import Combine

final class OrdersViewPresenter: ObservableObject {
    @Published var orders: [Order] = []
    @Published var selectedOrder: Order?
    @Published var sheetPresented = false
    
    init() {
    }
    
    init(orders: [Order]) {
        self.orders = orders
    }
    
    func showOrderSheet(order: Order) -> Void {
        self.selectedOrder = order
        self.sheetPresented.toggle()
    }
}
