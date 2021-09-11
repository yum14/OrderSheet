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
    
    private let router = OrderListRouter()
    
    init() {
    }
    
    init(orders: [Order]) {
        self.orders = orders
    }
    
    func showOrderSheet(order: Order) -> Void {
        self.selectedOrder = order
        self.sheetPresented.toggle()
    }
    
    func makeAboutOrderDetailView() -> some View {
        OrderDetailView(presenter: OrderDetailPresenter(order: self.selectedOrder!,
                                                            commitButtonTap: { self.sheetPresented.toggle() }))
    }
    
    func linkBuilder<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        NavigationLink(destination: router.makeNewOrderView()) {
            content()
        }
    }
}
