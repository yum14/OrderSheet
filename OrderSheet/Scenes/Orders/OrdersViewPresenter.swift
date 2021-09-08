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
    
    init() {
    }
    
    init(orders: [Order]) {
        self.orders = orders
    }
}
