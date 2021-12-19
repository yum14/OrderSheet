//
//  NotificationStore.swift
//  OrderSheet
//
//  Created by yum on 2021/12/12.
//

import Foundation
import Firebase

final class NotificationStore {
    private let db: Firestore
    private let collectionName = "notifications"

    init() {
        self.db = Firestore.firestore()
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
    }
    
    func set(_ newValue: Notification, completion: ((Result<(), Error>) -> Void)?) {
        let result = Result {
            try db.collection(self.collectionName).document(newValue.id).setData(from: newValue)
        }

        
        completion?(result)
    }
}
