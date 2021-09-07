//
//  OrderList.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI

struct OrderList: View {
    var orders: [Order] = []
    var onListItemTap: (Order) -> Void = { _ in }
    var onCartButtonTap: (Order) -> Void = { _ in }
    
    var body: some View {
        List {
            ForEach(self.orders, id: \.self) { order in
                HStack {
                    Text(order.name)
                        .lineLimit(0)
                    Spacer()
                    CartButton(font: .title2, onTap: { self.onCartButtonTap(order) })
                }
            }
        }
    }
}

struct OrderList_Previews: PreviewProvider {
    static var previews: some View {
        let orders = [Order(id: "a", name: "だいこん"),
                      Order(id: "b", name: "にんじん"),
                      Order(id: "c", name: "たまねぎ")]
        
        OrderList(orders: orders)
    }
}
