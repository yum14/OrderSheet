//
//  NewTeamInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/09/26.
//

import Foundation

protocol NewTeamUsecase {
    func addTeam(user: User, name: String, completion: @escaping (Result<Team?, Error>) -> Void)
}

final class NewTeamInteractor {
    private let teamStore = TeamStore()
    private let userStore = UserStore()
    
    init() {}
}

extension NewTeamInteractor: NewTeamUsecase {
    func addTeam(user: User, name: String, completion: @escaping (Result<Team?, Error>) -> Void = { _ in }) {
        
        let newTeam = Team(name: name, members: [user.id], owner: user.id, createdAt: Date())

        var teams = user.teams
        teams.append(newTeam.id)
        
        let newUser = User(id: user.id,
                           displayName: user.displayName,
                           email: user.email,
                           photoUrl: user.photoUrl,
                           avatarImage: user.avatarImage,
                           teams: teams,
                           selectedTeam: user.selectedTeam,
                           lastLogin: user.lastLogin)
        
        
        self.userStore.set(newUser) { userResult in
            switch userResult {
            case .success():
                self.teamStore.set(newTeam) { result in
                    switch result {
                    case .success():
                        completion(Result.success(newTeam))
                    case .failure(let error):
                        print(error.localizedDescription)
                        completion(Result.failure(error))
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(Result.failure(error))
            }
        }
    }
}
