//
//  OrderListInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/12.
//

import Foundation

protocol OrderListUsecase {
    func loadCurrentTeam(id: String, completion: ((Team?) -> Void)?)
    func setOrderListener(teamId: String, completion: (([Order]?) -> Void)?)
    func setUser(_ newUser: User, completion: ((Error?) -> Void)?)
}

final class OrderListInteractor {
    let teamStore = TeamStore()
    let userStore = UserStore()
    let orderStore = OrderStore()
}

extension OrderListInteractor: OrderListUsecase {
    func loadCurrentTeam(id: String, completion: ((Team?) -> Void)?) {
        self.teamStore.get(id: id) { result in
            switch result {
            case .success(let team):
                completion?(team)
                return
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            completion?(nil)
        }
    }
    
    func setOrderListener(teamId: String, completion: (([Order]?) -> Void)?) {
        self.orderStore.setListener(teamId: teamId, completion: completion)
    }
    
    func setUser(_ newUser: User, completion: ((Error?) -> Void)?) {
        self.userStore.set(newUser) { result in
            switch result {
            case .success():
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
}
