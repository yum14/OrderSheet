//
//  TeamStore.swift
//  OrderSheet
//
//  Created by yum on 2021/09/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

final class TeamStore {
    
    var teams: [Team] = [] {
        didSet {
            self.onListen?(teams)
        }
    }
    
    private let db: Firestore
    private let collectionName = "teams"
    private var onListen: ((_ newValue: [Team]) -> Void)?
    
    init() {
        self.db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func addSnapshotListener(onListen: @escaping (_ newValue: [Team]) -> Void) {
        self.onListen = onListen
        
        db.collection(self.collectionName)
            .whereField("disabled", isEqualTo: false)
            .order(by: "created_at")
            .addSnapshotListener { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("Error fetching documents: \(error!)")
                    return
                }
                
                let newTeams: [Team] = documents.compactMap { snapshot in
                    let result = Result {
                        try snapshot.data(as: Team.self)
                    }
                    
                    switch result {
                    case .success(let team):
                        if let team = team {
                            return team
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    
                    return nil
                }
                
                self.teams = newTeams
            }
    }
    
    func get(completion: @escaping (Result<[Team]?, Error>) -> Void = { _ in }) {
        db.collection(self.collectionName).getDocuments { (snapshot, error) in
            if let error = error {
                completion(Result.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(Result.success(nil))
                return
            }

            var teams: [Team] = []
            
            for document in documents {
                do {
                    let data = try document.data(as: Team.self)!
                    teams.append(data)
                } catch(let error) {
                    completion(Result.failure(error))
                    return
                }
            }
            
            completion(Result.success(teams))
        }
    }
    
    func get(id: String, completion: @escaping (Result<Team?, Error>) -> Void = { _ in }) {
        
        db.collection(self.collectionName).document(id).getDocument { (document, error) in
            let result = Result {
                try document?.data(as: Team.self)
            }
            
            completion(result)
        }
    }
    
    
    func get(containsUserId: String, completion: @escaping (Result<[Team]?, Error>) -> Void = { _ in }) {
        
        db.collection(self.collectionName).whereField("members", arrayContains: containsUserId).getDocuments { (snapshot, error) in
            if let error = error {
                completion(Result.failure(error))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(Result.success(nil))
                return
            }

            var teams: [Team] = []
            
            for document in documents {
                do {
                    let data = try document.data(as: Team.self)!
                    teams.append(data)
                } catch(let error) {
                    completion(Result.failure(error))
                    return
                }
            }
            
            completion(Result.success(teams))
        }
    }
    
    
    func set(_ team: Team, completion: ((Result<(), Error>) -> Void)? = { _ in }) {
        let result = Result {
            try db.collection(self.collectionName).document(team.id).setData(from: team)
        }
        
        completion?(result)
    }

    func disabled(id: String, completion: ((Error?) -> Void)?) {
        db.collection(self.collectionName).document(id).updateData(["disabled": true], completion: completion)
    }
}
