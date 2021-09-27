//
//  NewTeamInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/09/26.
//

import Foundation

protocol NewTeamUsecase {
    func addTeam(uid: String, name: String, completion: @escaping (Result<Team?, Error>) -> Void)
}

final class NewTeamInteractor {
    private let store: TeamStore
    
    init(store: TeamStore) {
        self.store = store
    }
}

extension NewTeamInteractor: NewTeamUsecase {
    func addTeam(uid: String, name: String, completion: @escaping (Result<Team?, Error>) -> Void = { _ in }) {

        let newTeam = Team(name: name, members: [Member(id: uid, owner: true)], createdAt: Date())

        self.store.set(newTeam, completion: { result in
            switch result {
            case .success():
                completion(.success(newTeam))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
