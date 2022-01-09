//
//  NewOrderInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/14.
//

import Foundation

protocol NewOrderUsecase {
    func addNewOrder(profile: Profile, team: Team, name: String, items: [OrderItem], comment: String?, completion: ((Result<Order?, Error>) -> Void)?)
}

final class NewOrderInteractor {
    let orderStore = OrderStore()
    let notificationStore = NotificationStore()
}

extension NewOrderInteractor: NewOrderUsecase {
    func addNewOrder(profile: Profile, team: Team, name: String, items: [OrderItem], comment: String?, completion: ((Result<Order?, Error>) -> Void)?) {
        
        let newOrder = Order(name: name,
                             items: items,
                             comment: comment,
                             owner: profile.id)
        
        self.orderStore.set(teamId: team.id, newOrder) { result in
            switch result {
            case .success():

                // プッシュ通知用コレクションにデータ追加
                let destination = team.members.filter { $0 != profile.id }
                if destination.count > 0 {
                    
                    let newNotification = NotificationUtility.createNewOrderNotification(userId: profile.id, userName: profile.displayName, destination: destination)
                    
                    self.notificationStore.set(newNotification) { notificationResult in
                        switch notificationResult {
                        case .success():
                            break
                        case .failure(let error):
                            print(error.localizedDescription)
                            completion?(Result.failure(error))
                            return
                        }
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)
                completion?(Result.failure(error))
                return
            }

            completion?(Result.success(newOrder))
        }
    }
}
