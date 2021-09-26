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
    
    private let db: Firestore
    private let collectionName = "teams"
    
    init() {
        self.db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func get(id: String, completion: @escaping (Result<Team?, Error>) -> Void = { _ in }) {
        
        db.collection(self.collectionName).document(id).getDocument { (document, error) in
            let result = Result {
                try document?.data(as: Team.self)
            }

            completion(result)
        }
    }
    
    func set(team: Team, completion: @escaping (Result<(), Error>) -> Void = { _ in }) {
        let result = Result {
            try db.collection(self.collectionName).document(team.id).setData(from: team)
        }
        
        completion(result)
    }
}
