//
//  HomeInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/06.
//

import Foundation

protocol HomeUsecase {
    func addSnapshotListener(onListen: @escaping ([Team]) -> Void)
    func loadTeams(userId: String, completion: @escaping (Result<[Team]?, Error>) -> Void)
    func getTeam(id: String, completion: @escaping (Result<Team?, Error>) -> Void)
    func addTeam(user: User, teamId: String, completion: @escaping (Result<(), Error>) -> Void)
}

final class HomeInteractor {
    let teamStore = TeamStore()
    let userStore = UserStore()
    init() {}
}

extension HomeInteractor: HomeUsecase {
    func addSnapshotListener(onListen: @escaping ([Team]) -> Void) {
        self.teamStore.addSnapshotListener(onListen: onListen)
    }
    
    func loadTeams(userId: String, completion: @escaping (Result<[Team]?, Error>) -> Void) {
        self.teamStore.get(containsUserId: userId, completion: completion)
    }
    
    func getTeam(id: String, completion: @escaping (Result<Team?, Error>) -> Void) {
        self.teamStore.get(id: id, completion: completion)
    }
    
    func addTeam(user: User, teamId: String, completion: @escaping (Result<(), Error>) -> Void) {
        self.teamStore.get(id: teamId) { teamResult in
            switch teamResult {
            case .success(let team):
                if let team = team {
                    
                    var newTeams = user.teams
                    newTeams.append(team.id)
                    
                    let newUser = User(id: user.id,
                                       displayName: user.displayName,
                                       email: user.email,
                                       photoUrl: user.photoUrl,
                                       avatarImage: user.avatarImage,
                                       teams: newTeams,
                                       selectedTeam: user.selectedTeam,
                                       lastLogin: user.lastLogin)
                    
                    self.userStore.set(newUser) { userResult in
                        switch userResult {
                        case .success():
                            
                            var newMembers = team.members
                            newMembers.append(user.id)
                            
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
                                    completion(Result.success(()))
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
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
