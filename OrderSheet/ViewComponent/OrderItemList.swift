//
//  OrderItemList.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI

struct OrderItemList: View {
    var products: [OrderItem] = []
    var onListItemTap: (OrderItem) -> Void = { _ in }
    var onCartButtonTap: (OrderItem) -> Void = { _ in }
    
    var body: some View {
        List {
            ForEach(self.products, id: \.self) { product in
                ZStack {
                    HStack {
                        Text(product.name)
                            .lineLimit(0)
                        Spacer()
                        CartButton(onTap: { self.onCartButtonTap(product) })
                            .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
    }
}

struct OrderItemList_Previews: PreviewProvider {
    static var previews: some View {
        let products = [OrderItem(name: "だいこん"),
                        OrderItem(name: "にんじん"),
                        OrderItem(name: "たまねぎ")]
        
        OrderItemList(products: products)
    }
}
