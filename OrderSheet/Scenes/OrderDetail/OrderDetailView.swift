//
//  OrderDetailView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI

struct OrderDetailView: View {
    @ObservedObject var presenter: OrderDetailPresenter
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("アイテム")) {
                        ProductList(products: self.presenter.order.items,
                                    onListItemTap: { _ in },
                                    onCartButtonTap: { _ in })
                    }
                    
                    Section(header: Text("コメント")) {
                        Text(self.presenter.order.comment ?? "")
                    }
                }

                
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

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order(name: "オーダー1",
                          items: [Product(name: "たまねぎ"),
                                  Product(name: "にんじん"),
                                  Product(name: "トイレットペーパー")])
        let presenter = OrderDetailPresenter(order: order)
        
        OrderDetailView(presenter: presenter)
    }
}
