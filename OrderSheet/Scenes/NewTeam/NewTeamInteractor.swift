//
//  NewTeamInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/09/26.
//

import Foundation

protocol NewTeamUsecase {
    func addTeam(profile: Profile, name: String, completion: ((Result<Team?, Error>) -> Void)?)
}

final class NewTeamInteractor {
    private let teamStore = TeamStore()
    private let userStore = UserStore()
    private let profileStore = ProfileStore()
    
    init() {}
}

extension NewTeamInteractor: NewTeamUsecase {
    func addTeam(profile: Profile, name: String, completion: ((Result<Team?, Error>) -> Void)?) {
        
        let newTeam = Team(name: name, avatarImage: nil, members: [profile.id], owner: profile.id, disabled: false, createdAt: Date())
        var newTeams = profile.teams
        newTeams.append(newTeam.id)
        
        self.profileStore.updateTeams(id: profile.id, newTeams: newTeams) { error in
            if let error = error {
                completion?(Result.failure(error))
                return
            }
            
            self.teamStore.set(newTeam) { result in
                switch result {
                case .success():
                    completion?(Result.success(newTeam))
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(Result.failure(error))
                }
            }
        }
    }
}
