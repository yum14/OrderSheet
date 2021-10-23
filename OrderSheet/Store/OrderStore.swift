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
    
    func setListener(teamId: String, completion: (([Order]?) -> Void)?) {
        db.collection(self.parentCollectionName).document(teamId).collection(self.collectionName)
            .addSnapshotListener { querySnapshot, error in
                self.snapshotListen(querySnapshot, error, completion: completion)
            }
    }

    private func snapshotListen(_ querySnapshot: QuerySnapshot?, _ error: Error?, completion: (([Order]?) -> Void)?) {
        guard let documents = querySnapshot?.documents else {
            print("Error fetching documents: \(error!)")
            return
        }
        
        let orders: [Order] = documents.compactMap { snapshot in
            let result = Result {
                try snapshot.data(as: Order.self)
            }
            
            switch result {
            case .success(let order):
                if let order = order {
                    return order
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            return nil
        }

        completion?(orders)
    }
    
    func set(teamId: String, _ newOrder: Order, completion: ((Result<(), Error>) -> Void)?) {
        let result = Result {
            try db.collection(self.parentCollectionName).document(teamId).collection(self.collectionName).document(newOrder.id).setData(from: newOrder)
        }
        
        completion?(result)
    }
    
    func updateItemChecked(teamId: String, id: String, checked: Bool, completion: ((Error?) -> Void)?) {
        db.collection(self.parentCollectionName).document(teamId).collection(self.collectionName).document(id).updateData(["checked": checked], completion: completion)
    }
}
