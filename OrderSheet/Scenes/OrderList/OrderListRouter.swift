//
//  OrderListRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

final class OrderListRouter {
    func makeNewOrderView() -> some View {
        let presenter = NewOrderPresenter()
        let view = NewOrderView(presenter: presenter)
        return view
    }
}
