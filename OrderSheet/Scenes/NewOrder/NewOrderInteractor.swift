//
//  NewOrderInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/14.
//

import Foundation

protocol NewOrderUsecase {
    func addNewOrder(teamId: String, _ name: String, items: [OrderItem], comment: String?, owner: String, completion: ((Result<Order?, Error>) -> Void)?)
}

final class NewOrderInteractor {
    let orderStore = OrderStore()
}

extension NewOrderInteractor: NewOrderUsecase {
    func addNewOrder(teamId: String, _ name: String, items: [OrderItem], comment: String?, owner: String, completion: ((Result<Order?, Error>) -> Void)?) {
        
        let newOrder = Order(name: name,
                             items: items,
                             comment: comment,
                             owner: owner)
        
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
}
