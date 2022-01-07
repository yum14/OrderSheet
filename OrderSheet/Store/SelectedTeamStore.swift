//
//  SelectedTeamStore.swift
//  OrderSheet
//
//  Created by yum on 2022/01/06.
//

import Foundation
import Firebase

final class SelectedTeamStore {
    private let db: Firestore
    private let parentCollectionName = "users"
    private let collectionName = "selected_team"
    
    init() {
        self.db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func get(userId: String, completion: ((Result<SelectedTeam?, Error>) -> Void)?) {
        db.collection(self.parentCollectionName).document(userId).collection(self.collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion?(Result.failure(error))
                return
            }
            
            let result = Result {
                // 1件のみしか保存しない
                try snapshot?.documents.first?.data(as: SelectedTeam.self)
            }
            
            completion?(result)
        }
    }
    
    func set(userId: String, _ newValue: SelectedTeam, completion: ((Result<(), Error>) -> Void)?) {

        self.db.collection(self.parentCollectionName).document(userId).collection(self.collectionName).getDocuments { snapshot, error in
            if let error = error {
                completion?(Result.failure(error))
                return
            }

            // はじめにドキュメント全削除
            for document in snapshot!.documents {
                document.reference.delete { error in
                    if let error = error {
                        completion?(Result.failure(error))
                        return
                    }
                }
            }
            
            let result = Result {
                try self.db.collection(self.parentCollectionName).document(userId).collection(self.collectionName).document(newValue.id).setData(from: newValue)
            }
            
            completion?(result)
        }
    }
}
