//
//  UserStore.swift
//  OrderSheet
//
//  Created by yum on 2021/09/26.
//

import Foundation
import Firebase

class UserStore {
    private let db: Firestore
    private let collectionName = "users"

    init() {
        self.db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func setListener(id: String, completion: ((User?) -> Void)?) {
        db.collection(self.collectionName).document(id)
            .addSnapshotListener { documentSnapshot, error in
                self.snapshotListen(documentSnapshot, error, completion: completion)
            }
    }

    private func snapshotListen(_ documentSnapshot: DocumentSnapshot?, _ error: Error?, completion: ((User?) -> Void)?) {

        let result = Result {
            try documentSnapshot?.data(as: User.self)
        }
        
        switch result {
        case .success(let user):
            if let user = user {
                completion?(user)
                return
            }
        case .failure(let error):
            print(error.localizedDescription)
        }

        completion?(nil)
    }
    
    func get(id: String, completion: @escaping (Result<User?, Error>) -> Void = { _ in }) {
        
        db.collection(self.collectionName).document(id).getDocument { (document, error) in
            let result = Result {
                try document?.data(as: User.self)
            }

            completion(result)
        }
    }
    
    func set(_ user: User, completion: @escaping (Result<(), Error>) -> Void = { _ in }) {
        let result = Result {
            try db.collection(collectionName).document(user.id).setData(from: user)
        }
        
        completion(result)
    }
}
