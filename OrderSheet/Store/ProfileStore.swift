//
//  ProfileStore.swift
//  OrderSheet
//
//  Created by yum on 2022/01/07.
//

import Foundation
import Firebase

final class ProfileStore {
    private let db: Firestore
    private let collectionName = "profiles"
    
    init() {
        self.db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func get(id: String, completion: @escaping (Result<Profile?, Error>) -> Void) {
        
        db.collection(self.collectionName).document(id).getDocument { (document, error) in
            let result = Result {
                try document?.data(as: Profile.self)
            }

            completion(result)
        }
    }
    
    func get(ids: [String], completion: @escaping (Result<[Profile]?, Error>) -> Void) {
        
        db.collection(self.collectionName).whereField("id", in: ids).getDocuments { querySnapshot, error in
            if let error = error {
                completion(Result.failure(error))
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                completion(Result.success(nil))
                return
            }

            var profiles: [Profile] = []
            
            for document in documents {
                do {
                    let data = try document.data(as: Profile.self)!
                    profiles.append(data)
                    completion(Result.success(profiles))
                } catch(let error) {
                    completion(Result.failure(error))
                }
            }
        }
        
    }
    
    func set(_ profile: Profile, completion: ((Result<(), Error>) -> Void)?) {

        let result = Result {
            try db.collection(collectionName).document(profile.id).setData(from: profile)
        }
        
        completion?(result)
    }
    
    func updateTeams(id: String, newTeams: [String], completion: ((Error?) -> Void)?) {
        db.collection(self.collectionName).document(id).updateData(["teams": newTeams], completion: completion)
    }
    
    func updateDisplayName(id: String, displayName: String, completion: ((Error?) -> Void)?) {
        db.collection(self.collectionName).document(id).updateData(["display_name": displayName], completion: completion)
    }
    
    func updateAvatarImage(id: String, avatarImage: Data, completion: ((Error?) -> Void)?) {
        db.collection(self.collectionName).document(id).updateData(["avatar_image": avatarImage], completion: completion)
    }
    
    func updateSelectedTeam(id: String, selectedTeamId: String, completion: ((Error?) -> Void)?) {
        db.collection(self.collectionName).document(id).updateData(["selected_team": selectedTeamId], completion: completion)
    }
}
