//
//  OrderListView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI
import GoogleSignIn

struct OrderListView: View {
    @ObservedObject var presenter: OrderListPresenter
    
    var body: some View {
        NavigationView {
            VStack {
                OrderList(orders: self.presenter.orders,
                          onRowTap: self.presenter.showOrderSheet)
            }
            .sheet(isPresented: self.$presenter.sheetPresented) {
                self.presenter.makeAboutOrderDetailView()
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Button(action: { FirebaseAuth
                                                    .signOut() }, label: {
                Text("ログアウト")
            }),
            trailing: self.presenter.linkBuilder {
                Image(systemName: "plus")
            })
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        let template = "yyyy/MM/dd HH:mm:ss"
        
        let products = [Product(name: "たまねぎ"),
                        Product(name: "にんじん"),
                        Product(name: "トイレットペーパー")]
        
        let orders = [Order(name: "オーダー1", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))]
        
        let presenter = OrderListPresenter(orders: orders)
        
        VStack {
            OrderListView(presenter: presenter)
        }
    }
}
