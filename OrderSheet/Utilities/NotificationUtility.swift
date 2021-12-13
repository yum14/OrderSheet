//
//  NotificationUtility.swift
//  OrderSheet
//
//  Created by yum on 2021/12/13.
//

import Foundation

class NotificationUtility {
    static func createNewOrderNotification(userId: String, userName: String, destination: [String]) -> Notification {
        return Notification(userId: userId, title: "コレカッテキテ", body: "\(userName)さんから新しいオーダーが入りました！", members: destination)
    }
    
    static func createOrderCompleteNotification(userId: String, userName: String, destination: [String]) -> Notification {
        return Notification(userId: userId, title: "コレカッテキテ", body: "\(userName)さんがオーダーを完了しました！", members: destination)
    }
}
