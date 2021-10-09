//
//  RootRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

final class RootRouter {
    let orderListPresenter: OrderListPresenter
    let loginPresener: LoginPresenter
    let homePresenter: HomePresenter
    
    init() {
        let products = [Product(name: "たまねぎ"),
                        Product(name: "にんじん"),
                        Product(name: "トイレットペーパー")]
        let template = "yyyy/MM/dd HH:mm:ss"
        let orders = [Order(name: "オーダー1", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))]
        
        self.orderListPresenter = OrderListPresenter(orders: orders)
        self.loginPresener = LoginPresenter()
        
        let homeInteractor = HomeInteractor()
        let homeRouter = HomeRouter()
        self.homePresenter = HomePresenter(interactor: homeInteractor, router: homeRouter)
    }
    

    func makeOrderListView() -> some View {
        let view = OrderListView(presenter: self.orderListPresenter)
        return view
    }
    
    func makeLoginView() -> some View {
        let view = LoginView(presenter: self.loginPresener)
        return view
    }
    
    func makeHomeView() -> some View {
        let view = HomeView(presenter: self.homePresenter)
        return view
    }
}
