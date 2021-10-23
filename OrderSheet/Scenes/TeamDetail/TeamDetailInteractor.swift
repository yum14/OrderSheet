//
//  TeamDetailInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/07.
//

import Foundation
import SwiftUI

protocol TeamDetailUsecase {
    func teamLoad(id: String, completion: @escaping (Team?) -> Void)
    func memberLoad(ids: [String], completion: @escaping ([User]?) -> Void)
    func set(_ newValue: Team)
    func leaveMember(user: User, team: Team, completion: ((Error?) -> Void)?)
    func deleteTeamAndOrder(id: String, completion: ((Error?) -> Void)?)
}

final class TeamDetailInteractor {
    let teamStore = TeamStore()
    let userStore = UserStore()
    
    init() {}
}

extension TeamDetailInteractor: TeamDetailUsecase {
    func teamLoad(id: String, completion: @escaping (Team?) -> Void) {
        self.teamStore.get(id: id, completion: { result in
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
    
    func memberLoad(ids: [String], completion: @escaping ([User]?) -> Void) {
        self.userStore.get(ids: ids) { result in
            switch result {
            case .success(let users):
                if let users = users {
                    completion(users)
                    return
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            completion(nil)
        }
        
    }
    
    
    func set(_ newValue: Team) {
        self.teamStore.set(newValue)
    }
    
    func leaveMember(user: User, team: Team, completion: ((Error?) -> Void)?) {
        guard let teamIndex = team.members.firstIndex(where: { $0 == user.id }) else {
            return
        }
                
        guard let userIndex = user.teams.firstIndex(where: { $0 == team.id }) else {
            return
        }

        var newTeams = user.teams
        newTeams.remove(at: userIndex)
        
        let newUser = User(id: user.id,
                           displayName: user.displayName,
                           email: user.email,
                           photoUrl: user.photoUrl,
                           avatarImage: user.avatarImage,
                           teams: newTeams,
                           selectedTeam: user.selectedTeam,
                           lastLogin: user.lastLogin)
        
        self.userStore.set(newUser) { result in
            switch result {
            case .success():
                break
            case .failure(let error):
                print(error.localizedDescription)
                completion?(error)
                return
            }
            
            var newMembers = team.members
            newMembers.remove(at: teamIndex)
            let newTeam = Team(id: team.id,
                               name: team.name,
                               avatarImage: team.avatarImage,
                               members: newMembers,
                               owner: team.owner,
                               createdAt: team.createdAt?.dateValue(),
                               updatedAt: Date())
            
            self.teamStore.set(newTeam) { result in
                switch result {
                case .success():
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(error)
                    return
                }
                
                completion?(nil)
            }
        }
    }
    
    func deleteTeamAndOrder(id: String, completion: ((Error?) -> Void)?) {
        self.teamStore.disabled(id: id, completion: completion)
    }
}
