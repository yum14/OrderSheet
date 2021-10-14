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
    @EnvironmentObject var authStateObserver: AuthStateObserver
    
    var body: some View {
        NavigationView {
            VStack {
                OrderList(orders: self.presenter.orders,
                          onRowTap: self.presenter.showOrderDetailSheet)
                .onAppear {
                    self.presenter.load(user: self.authStateObserver.appUser!)
                }
            }
            .sheet(isPresented: self.$presenter.sheetPresented) {
                if let sheetType = self.presenter.sheetType, sheetType == .OrderDetail {
                    self.presenter.makeAboutOrderDetailSheetView()
                } else {
                    self.presenter.makeAboutNewOrderSheetView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: Text(self.presenter.selectedTeam?.name ?? ""),
                                trailing: Button(action: self.presenter.showNewOrderSheet) {
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
        
        let interactor = OrderListInteractor()
        let router = OrderListRouter()
        let presenter = OrderListPresenter(interactor: interactor, router: router, orders: orders)
        let authStateObserver = AuthStateObserver()
        
        VStack {
            OrderListView(presenter: presenter)
                .environmentObject(authStateObserver)
        }
    }
}
