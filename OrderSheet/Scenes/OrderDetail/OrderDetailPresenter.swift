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
    @Published var order: Order
    @Published var showingOrderCommmitConfirm = false
    
    private var commitButtonTap: (() -> Void)?
    private var editButtonTap: (() -> Void)?
    private var team: Team
    private var interactor: OrderDetailUsecase
    
    var editable: Bool {
        return !self.order.committed
    }
    
    init(interactor: OrderDetailUsecase, team: Team, order: Order, commitButtonTap: (() -> Void)?, editButtonTap: (() -> Void)?) {
        self.order = order
        self.team = team
        self.commitButtonTap = commitButtonTap
        self.editButtonTap = editButtonTap
        self.interactor = interactor
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
}
