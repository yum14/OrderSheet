//
//  RootRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

final class RootRouter {
    func makeOrderListView() -> some View {
        let products = [Product(name: "たまねぎ"),
                        Product(name: "にんじん"),
                        Product(name: "トイレットペーパー")]
        let template = "yyyy/MM/dd HH:mm:ss"
        let orders = [Order(name: "オーダー1", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))]
        
        let presenter = OrderListPresenter(orders: orders)
        let view = OrderListView(presenter: presenter)
        return view
    }
    
    func makeLoginView() -> some View {
        let presenter = LoginPresenter()
        let view = LoginView(presenter: presenter)
        return view
    }
    
    func makeHomeView() -> some View {
        let presenter = HomePresenter(user: User(name: "アカウント名", teams: [Team(name: "チーム1"), Team(name: "チーム2")]))
        let view = HomeView(presenter: presenter)
        return view
    }
}
