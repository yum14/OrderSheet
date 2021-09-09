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
        VStack {
            OrderList(orders: self.presenter.orders, onRowTap: self.presenter.showOrderSheet)
        }
        .sheet(isPresented: self.$presenter.sheetPresented) {
            ProductList(products: self.presenter.selectedOrder?.items ?? [])
        }
    }
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        let template = "yyyy/MM/dd HH:mm:ss"
        
        let products = [Product(name: "たまねぎ"),
                        Product(name: "にんじん"),
                        Product(name: "トイレットペーパー")]
        
        let orders = [Order(name: "オーダー1", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))]
        
        let presenter = OrdersViewPresenter(orders: orders)
        
        VStack {
            OrdersView(presenter: presenter)
        }
    }
}
