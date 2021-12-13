//
//  OrderDetailInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/10/22.
//

import Foundation

protocol OrderDetailUsecase {
    func updateOrder(teamId: String, order: Order, completion: ((Error?) -> Void)?)
    func updateOrderAndNotification(user: User, teamId: String, order: Order, completion: ((Error?) -> Void)?)
}

final class OrderDetailInteractor {
    private let orderStore = OrderStore()
    private let notificationStore = NotificationStore()
}

extension OrderDetailInteractor: OrderDetailUsecase {
    
    func updateOrder(teamId: String, order: Order, completion: ((Error?) -> Void)?) {
        self.orderStore.set(teamId: teamId, order) { result in
            switch result {
            case .success():
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }
    
    func updateOrderAndNotification(user: User, teamId: String, order: Order, completion: ((Error?) -> Void)?) {
        self.orderStore.set(teamId: teamId, order) { result in
            switch result {
            case .success():

                // オーダー作成者自身が完了した場合は通知しない
                if user.id == order.owner {
                    break
                }
                // プッシュ通知用コレクションにデータ追加
                let newNotification = Notification(userId: user.id, title: "コレカッテキテ", body: "\(user.displayName)さんがオーダーを完了しました！", members: [order.owner])
                
                self.notificationStore.set(newNotification) { notificationResult in
                    switch notificationResult {
                    case .success():
                        break
                    case .failure(let error):
                        completion?(error)
                        return
                    }
                }
            case .failure(let error):
                completion?(error)
                return
            }
            
            completion?(nil)
        }
    }
}
