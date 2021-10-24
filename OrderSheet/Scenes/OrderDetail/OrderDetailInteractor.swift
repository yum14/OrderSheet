//
//  OrderDetailInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/22.
//

import Foundation

protocol OrderDetailUsecase {
    func updateOrderItems(teamId: String, orderId: String, items: [OrderItem], completion: ((Error?) -> Void)?)
    func updateOrder(teamId: String, order: Order, completion: ((Error?) -> Void)?)
}

final class OrderDetailInteractor {
    private let orderStore = OrderStore()
    
    init() {}
}

extension OrderDetailInteractor: OrderDetailUsecase {
    func updateOrderItems(teamId: String, orderId: String, items: [OrderItem], completion: ((Error?) -> Void)?) {
        self.orderStore.updateOrderItems(teamId: teamId, orderId: orderId, items: items, completion: completion)
    }
    
    func updateOrder(teamId: String, order: Order, completion: ((Error?) -> Void)?) {
        self.orderStore.set(teamId: teamId, order) { result in
            switch result {
            case .success():
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
}
