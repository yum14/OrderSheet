//
//  OrderDetailPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import Foundation
import SwiftUI
import Combine

final class OrderDetailPresenter: ObservableObject {
    @Published var showingOrderCommmitConfirm = false
    @Published var showingUnlockConfirm = false
    
    var order: Order
    var owner: User
    
    var formLocked: Bool {
        return self.order.committed
    }
    
    private var commitButtonTap: (() -> Void)?
    private var editButtonTap: (() -> Void)?
    private var team: Team
    private var interactor: OrderDetailUsecase
    
    var editable: Bool {
        return !self.order.committed
    }
    
    init(interactor: OrderDetailUsecase, team: Team, order: Order, owner: User, commitButtonTap: (() -> Void)?, editButtonTap: (() -> Void)?) {
        self.order = order
        self.team = team
        self.commitButtonTap = commitButtonTap
        self.editButtonTap = editButtonTap
        self.interactor = interactor
        self.owner = owner        
    }
    
    func commitButtonTapped() {
        self.showingOrderCommmitConfirm = true
    }
    
    func commit() {
        let commitOrder = Order(id: self.order.id,
                                name: self.order.name,
                                items: self.order.items,
                                comment: self.order.comment,
                                committed: true,
                                owner: self.order.owner,
                                createdAt: self.order.createdAt.dateValue(),
                                updatedAt: Date())
        
        self.interactor.updateOrder(teamId: self.team.id, order: commitOrder) { error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            self.commitButtonTap?()
        }
    }
    
    func updateItemChecked(itemId: String, checked: Bool) {
        let items = self.order.items.map { item -> OrderItem in
            if item.id == itemId {
                return OrderItem(id: itemId, name: item.name, checked: checked)
            } else {
                return item
            }
        }
        
        let newOrder = Order(id: self.order.id,
                             name: self.order.name,
                             items: items,
                             comment: self.order.comment,
                             owner: self.order.owner,
                             createdAt: self.order.createdAt.dateValue(),
                             updatedAt: Date())
        
        self.interactor.updateOrder(teamId: self.team.id, order: newOrder) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func onEditButtonTap() {
        self.editButtonTap?()
    }
    
    func onUnlockButtonTap() {
        self.showingUnlockConfirm = true
    }
    
    func unlock() {
        let newOrder = Order(id: self.order.id,
                             name: self.order.name,
                             items: self.order.items,
                             comment: self.order.comment,
                             committed: false,
                             owner: self.order.owner,
                             createdAt: self.order.createdAt.dateValue(),
                             updatedAt: Date())
        
        self.interactor.updateOrder(teamId: self.team.id, order: newOrder) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
