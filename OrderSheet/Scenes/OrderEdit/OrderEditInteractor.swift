//
//  OrderEditInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/30.
//

import Foundation

protocol OrderEditUsecase {
    func getOrder(teamId: String, orderId: String, completion: ((Result<Order?, Error>) -> Void)?)
    func updateOrder(teamId: String, order: Order, completion: ((Result<Order?, Error>) -> Void)?)
    func deleteOrder(teamIid: String, orderId: String, completion: ((Error?) -> Void)?)
}

final class OrderEditInteractor {
    let orderStore = OrderStore()
}

extension OrderEditInteractor: OrderEditUsecase {
    func getOrder(teamId: String, orderId: String, completion: ((Result<Order?, Error>) -> Void)?) {
        
        self.orderStore.get(teamId: teamId, id: orderId, completion: completion)
    }
    
    func updateOrder(teamId: String, order: Order, completion: ((Result<Order?, Error>) -> Void)?) {
        
        let newOrder = Order(id: order.id,
                             name: order.name,
                             items: order.items,
                             comment: order.comment,
                             committed: order.committed,
                             createdAt: order.createdAt.dateValue(),
                             updatedAt: Date())
        
        self.orderStore.set(teamId: teamId, newOrder) { result in
            switch result {
            case .success():
                completion?(Result.success(newOrder))
            case .failure(let error):
                print(error.localizedDescription)
                completion?(Result.failure(error))
            }
        }
    }
    
    func deleteOrder(teamIid: String, orderId: String, completion: ((Error?) -> Void)?) {
        self.orderStore.delete(teamId: teamIid, orderId: orderId, completion: completion)
    }
}
