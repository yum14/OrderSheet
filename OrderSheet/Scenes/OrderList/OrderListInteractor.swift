//
//  OrderListInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/12.
//

import Foundation
import CloudKit

protocol OrderListUsecase {
    func loadTeams(userId: String, completion: (([Team]?) -> Void)?)
    func loadSelectedTeam(userId: String, completion: ((SelectedTeam?) -> Void)?)
    func setOrderListener(teamId: String, completion: (([Order]?) -> Void)?)
    func setUser(_ newUser: User, completion: ((Error?) -> Void)?)
    func setSelectedTeam(userId: String, _ newValue: SelectedTeam, completion: ((Error?) -> Void)?)
    func getUser(ids: [String], completion: @escaping (Result<[User]?, Error>) -> Void)
}

final class OrderListInteractor {
    let teamStore = TeamStore()
    let userStore = UserStore()
    let orderStore = OrderStore()
    let selectedTeamStore = SelectedTeamStore()
}

extension OrderListInteractor: OrderListUsecase {
    func loadTeams(userId: String, completion: (([Team]?) -> Void)?) {
        self.teamStore.get(containsUserId: userId) { result in
            switch result {
            case .success(let teams):
                if let teams = teams {
                    completion?(teams)
                    return
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            completion?(nil)
        }
    }
    
    func loadSelectedTeam(userId: String, completion: ((SelectedTeam?) -> Void)?) {
        self.selectedTeamStore.get(userId: userId) { result in
            switch result {
            case .success(let selectedTeam):
                if let selectedTeam = selectedTeam {
                    completion?(selectedTeam)
                    return
                }
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
    
    func setSelectedTeam(userId: String, _ newValue: SelectedTeam, completion: ((Error?) -> Void)?) {
        self.selectedTeamStore.set(userId: userId, newValue) { result in
            switch result {
            case .success():
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    func getUser(ids: [String], completion: @escaping (Result<[User]?, Error>) -> Void) {
        self.userStore.get(ids: ids, completion: completion)
    }
}
