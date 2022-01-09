//
//  HomeInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/06.
//

import Foundation
import CloudKit

protocol HomeUsecase {
    func getProfile(id: String, completion: @escaping (Result<Profile?, Error>) -> Void)
    func getTeams(userId: String, completion: @escaping (Result<[Team]?, Error>) -> Void)
    func getTeam(id: String, completion: @escaping (Result<Team?, Error>) -> Void)
    func addTeam(profile: Profile, teamId: String, completion: ((Error?) -> Void)?)
    func updateUserDisplayName(id: String, displayName: String, completion: ((Error?) -> Void)?)
    func updateAvatarImage(id: String, avatarImage: Data, completion: ((Error?) -> Void)?)
    func getTeams(teamIds: [String], completion: @escaping (Result<[Team]?, Error>) -> Void)
}

final class HomeInteractor {
    let teamStore = TeamStore()
    let userStore = UserStore()
    let profileStore = ProfileStore()
    init() {}
}

extension HomeInteractor: HomeUsecase {
    func getProfile(id: String, completion: @escaping (Result<Profile?, Error>) -> Void) {
        self.profileStore.get(id: id, completion: completion)
    }
    
    func getTeams(userId: String, completion: @escaping (Result<[Team]?, Error>) -> Void) {
        self.teamStore.get(containsUserId: userId, completion: completion)
    }
    
    func getTeams(teamIds: [String], completion: @escaping (Result<[Team]?, Error>) -> Void) {
        self.teamStore.get(ids: teamIds, completion: completion)
    }
    
    func getTeam(id: String, completion: @escaping (Result<Team?, Error>) -> Void) {
        self.teamStore.get(id: id, completion: completion)
    }
    
    func addTeam(profile: Profile, teamId: String, completion: ((Error?) -> Void)?) {
        self.teamStore.get(id: teamId) { teamResult in
            switch teamResult {
            case .success(let team):
                if let team = team {
                    
                    var newTeams = profile.teams
                    newTeams.append(team.id)

                    self.profileStore.updateTeams(id: profile.id, newTeams: newTeams) { error in
                        if let error = error {
                            completion?(error)
                            return
                        }
                        
                        var newMembers = team.members
                        newMembers.append(profile.id)
                        
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
                                completion?(error)
                            }
                        }
                    }
                }
                
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    func updateUserDisplayName(id: String, displayName: String, completion: ((Error?) -> Void)?) {
        self.profileStore.updateDisplayName(id: id, displayName: displayName, completion: completion)
    }
    
    func updateAvatarImage(id: String, avatarImage: Data, completion: ((Error?) -> Void)?) {
        self.profileStore.updateAvatarImage(id: id, avatarImage: avatarImage, completion: completion)
    }
}
