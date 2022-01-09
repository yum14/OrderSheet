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
    func loadProfile(userId: String, completion: ((Profile?) -> Void)?)
    func setOrderListener(teamId: String, completion: (([Order]?) -> Void)?)
    func setUser(_ newUser: User, completion: ((Error?) -> Void)?)
//    func setProfile(userId: String, _ newValue: Profile, completion: ((Error?) -> Void)?)
//    func getUser(ids: [String], completion: @escaping (Result<[User]?, Error>) -> Void)
    func getProfiles(ids: [String], completion: @escaping (Result<[Profile]?, Error>) -> Void)
    func updateSelectedTeam(id: String, selectedTeamId: String, completion: ((Error?) -> Void)?)
}

final class OrderListInteractor {
    let teamStore = TeamStore()
    let userStore = UserStore()
    let orderStore = OrderStore()
    let profileStore = ProfileStore()
}

extension OrderListInteractor: OrderListUsecase {
    func loadTeams(userId: String, completion: (([Team]?) -> Void)?) {
        self.teamStore.get(containsUserId: userId) { result in
            switch result {
            case .success(let teams):
                completion?(teams)
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
        }
    }
    
    func loadProfile(userId: String, completion: ((Profile?) -> Void)?) {
        self.profileStore.get(id: userId) { result in
            switch result {
            case .success(let profile):
                completion?(profile)
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
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
    
//    func setProfile(userId: String, _ newValue: Profile, completion: ((Error?) -> Void)?) {
//        self.profileStore.set(userId: userId, newValue) { result in
//            switch result {
//            case .success():
//                completion?(nil)
//            case .failure(let error):
//                completion?(error)
//            }
//        }
//    }
    
//    func getUser(ids: [String], completion: @escaping (Result<[User]?, Error>) -> Void) {
//        self.userStore.get(ids: ids, completion: completion)
//    }
    
    func getProfiles(ids: [String], completion: @escaping (Result<[Profile]?, Error>) -> Void) {
        self.profileStore.get(ids: ids, completion: completion)
    }
    
    func updateSelectedTeam(id: String, selectedTeamId: String, completion: ((Error?) -> Void)?) {
        self.profileStore.updateSelectedTeam(id: id, selectedTeamId: selectedTeamId, completion: completion)
    }
}
