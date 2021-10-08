//
//  TeamDetailInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/07.
//

import Foundation
import SwiftUI

protocol TeamDetailUsecase {
    func get(id: String, completion: @escaping (Team?) -> Void)
    func set(_ newValue: Team)
}

final class TeamDetailInteractor {
    let store = TeamStore()
    
    init() {}
}

extension TeamDetailInteractor: TeamDetailUsecase {
    func get(id: String, completion: @escaping (Team?) -> Void) {
        self.store.get(id: id, completion: { result in
            switch result {
            case .success(let team):
                if let team = team {
                    completion(team)
                    return
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            completion(nil)
        })
    }
    
    func set(_ newValue: Team) {
        store.set(newValue)
    }
}
