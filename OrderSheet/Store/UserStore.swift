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
    
    func set(_ user: User, completion: @escaping (Result<(), Error>) -> Void = { _ in }) {
        let result = Result {
            try db.collection(collectionName).document(user.id).setData(from: user)
        }
        
        completion(result)
    }
}
