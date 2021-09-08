//
//  OrdersView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI

struct OrdersView: View {
    @ObservedObject var presenter: OrdersViewPresenter
    var body: some View {
        OrderList(orders: self.presenter.orders)
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        let template = "yyyy/MM/dd HH:mm:ss"
        let orders = [Order(name: "オーダー1", createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))]
                      
        OrdersView(presenter: OrdersViewPresenter(orders: orders))
    }
}
