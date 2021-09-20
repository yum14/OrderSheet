//
//  ProductList.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI

struct ProductList: View {
    var products: [Product] = []
    var onListItemTap: (Product) -> Void = { _ in }
    var onCartButtonTap: (Product) -> Void = { _ in }
    
    var body: some View {
        List {
            ForEach(self.products, id: \.self) { product in
                HStack {
                    Text(product.name)
                        .lineLimit(0)
                    Spacer()
                    CartButton(onTap: { self.onCartButtonTap(product) })
                }
            }
        }
    }
}

struct ProductList_Previews: PreviewProvider {
    static var previews: some View {
        let products = [Product(name: "だいこん"),
                        Product(name: "にんじん"),
                        Product(name: "たまねぎ")]
        
        ProductList(products: products)
    }
}
