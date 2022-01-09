//
//  TeamDetailInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/07.
//

import Foundation
import SwiftUI

protocol TeamDetailUsecase {
    func memberLoad(ids: [String], completion: (([Profile]?) -> Void)?)
    func set(_ newValue: Team, completion: ((Error?) -> Void)?)
    func leaveMember(profile: Profile, team: Team, completion: ((Error?) -> Void)?)
    func deleteTeamAndOrder(id: String, completion: ((Error?) -> Void)?)
    func updateAvatarImage(id: String, avatarImage: Data, completion: ((Error?) -> Void)?)
}

final class TeamDetailInteractor {
    let teamStore = TeamStore()
//    let userStore = UserStore()
    let profileStore = ProfileStore()
    
    init() {}
}

extension TeamDetailInteractor: TeamDetailUsecase {
    func memberLoad(ids: [String], completion: (([Profile]?) -> Void)?) {
        self.profileStore.get(ids: ids) { result in
            switch result {
            case .success(let profiles):
                if let profiles = profiles {
                    completion?(profiles)
                } else {
                    completion?(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion?(nil)
            }
        }
    }
    
    func set(_ newValue: Team, completion: ((Error?) -> Void)?) {
        self.teamStore.set(newValue) { result in
            switch result {
            case .success():
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    func leaveMember(profile: Profile, team: Team, completion: ((Error?) -> Void)?) {
        guard let teamIndex = team.members.firstIndex(where: { $0 == profile.id }) else {
            return
        }
                
        guard let userIndex = profile.teams.firstIndex(where: { $0 == team.id }) else {
            return
        }

        var newTeams = profile.teams
        newTeams.remove(at: userIndex)
        
        self.profileStore.updateTeams(id: profile.id, newTeams: newTeams) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            var newMembers = team.members
            newMembers.remove(at: teamIndex)
            let newTeam = Team(id: team.id,
                               name: team.name,
                               avatarImage: team.avatarImage,
                               members: newMembers,
                               owner: team.owner,
                               createdAt: team.createdAt.dateValue(),
                               updatedAt: Date())
            
            self.teamStore.set(newTeam) { result in
                switch result {
                case .success():
                    completion?(nil)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion?(error)
                }
            }
        }
    }
    
    func deleteTeamAndOrder(id: String, completion: ((Error?) -> Void)?) {
        self.teamStore.disabled(id: id, completion: completion)
    }
    
    func updateAvatarImage(id: String, avatarImage: Data, completion: ((Error?) -> Void)?) {
        self.teamStore.updateAvatarImage(id: id, avatarImage: avatarImage, completion: completion)
    }
}
