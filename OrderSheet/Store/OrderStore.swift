//
//  OrderStore.swift
//  OrderSheet
//
//  Created by yum on 2021/10/14.
//

import Foundation
import Firebase

class OrderStore {
    private let db: Firestore
    private let parentCollectionName = "teams"
    private let collectionName = "orders"

    init() {
        self.db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func set(teamId: String, _ newOrder: Order, completion: @escaping (Result<(), Error>) -> Void = { _ in }) {
        let result = Result {
            try db.collection(self.parentCollectionName).document(teamId).collection(self.collectionName).document(newOrder.id).setData(from: newOrder)
        }
        
        completion(result)
    }
}
