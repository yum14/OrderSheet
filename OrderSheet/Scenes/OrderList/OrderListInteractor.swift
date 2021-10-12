//
//  OrderListInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/12.
//

import Foundation

protocol OrderListUsecase {
    func loadCurrentTeam(id: String, completion: @escaping (Team?) -> Void)
}

final class OrderListInteractor {
    let teamStore = TeamStore()
}

extension OrderListInteractor: OrderListUsecase {
    func loadCurrentTeam(id: String, completion: @escaping (Team?) -> Void) {
        self.teamStore.get(id: id) { result in
            switch result {
            case .success(let team):
                completion(team)
                return
            case .failure(let error):
                print(error.localizedDescription)
            }

            completion(nil)
        }
    }
}
