//
//  OrderSheetViewPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import Foundation
import SwiftUI
import Combine

final class OrderSheetViewPresenter: ObservableObject {
    @Published var order: Order
    var commitButtonTap: () -> Void = {}
    
    init(order: Order, commitButtonTap: @escaping () -> Void = {}) {
        self.order = order
        self.commitButtonTap = commitButtonTap
    }
    
    
}
