//
//  OrderDetailInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/22.
//

import Foundation

protocol OrderDetailUsecase {
    func updateOrder(teamId: String, order: Order, completion: ((Error?) -> Void)?)
    func getUser(id: String, completion: @escaping (Result<User?, Error>) -> Void)
}

final class OrderDetailInteractor {
    private let orderStore = OrderStore()
    private let userStore = UserStore()
    init() {}
}

extension OrderDetailInteractor: OrderDetailUsecase {
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
    
    func getUser(id: String, completion: @escaping (Result<User?, Error>) -> Void) {
        self.userStore.get(id: id, completion: completion)
    }
}
