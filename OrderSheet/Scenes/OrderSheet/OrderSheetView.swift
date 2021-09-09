//
//  OrderSheetView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI

struct OrderSheetView: View {
    @ObservedObject var presenter: OrderSheetViewPresenter
    
    var body: some View {
        NavigationView {
            VStack {
                ProductList(products: self.presenter.order.items,
                            onListItemTap: { _ in },
                            onCartButtonTap: { _ in })
                
                HStack {
                    Spacer()
                    CommitButton(onTap: self.presenter.commitButtonTap)
                        .padding()
                }
            }
            .navigationTitle(self.presenter.order.name)
            .navigationBarTitleDisplayMode(.inline)
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct OrderSheetView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order(name: "オーダー1",
                          items: [Product(name: "たまねぎ"),
                                  Product(name: "にんじん"),
                                  Product(name: "トイレットペーパー")])
        let presenter = OrderSheetViewPresenter(order: order)
        
        OrderSheetView(presenter: presenter)
    }
}
