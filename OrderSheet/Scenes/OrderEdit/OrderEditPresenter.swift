//
//  OrderEditPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/10/30.
//

import Foundation

final class OrderEditPresenter: ObservableObject {
    @Published var title: String
    @Published var items: [EditableListContent]
    @Published var comment: String
    @Published var showNewItem: Bool
    @Published var newItemText: String
    @Published var showingDeleteOrderConfirm = false
    
    private var interactor: OrderEditUsecase
    private var team: Team
    private var order: Order
    
    var saveButtonDisabled: Bool {
        return !(!self.title.isEmpty && self.items.count > 0)
    }
    
    init(interactor: OrderEditUsecase,
         team: Team,
         order: Order) {
        self.interactor = interactor
        self.team = team
        self.order = order
        self.title = order.name
        self.items = order.items.map { EditableListContent(id: $0.id, text: $0.name) }
        self.comment = order.comment ?? ""
        self.showNewItem = false
        self.newItemText = ""
    }
    
    func addItem() {
        self.showNewItem = true
    }
    
    func commitNewItemInput() {
        if !self.newItemText.isEmpty {
            self.items.append(EditableListContent(text: self.newItemText))
        }
        
        if self.items.count > 0 {
            self.showNewItem = false
        }
        
        self.newItemText = ""
    }
    
    var addItemButtonDisabled: Bool {
        return self.items.count == 0 || self.showNewItem
    }
    
    func updateOrder() {
        
        var newOrder = self.order
        newOrder.name = self.title
        newOrder.items = self.items.map { item in
            OrderItem(id: item.id, name: item.text, checked: self.order.items.first(where: { $0.id == item.id })!.checked )
        }
        newOrder.comment = self.comment
        
        self.interactor.updateOrder(teamId: self.team.id, order: newOrder) { result in
            switch result {
            case .success(let order):
                if let order = order {
                    self.order = order
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showDeleteOrderConfirm() {
        self.showingDeleteOrderConfirm = true
    }
    
    func deleteOrder() {
        self.interactor.deleteOrder(teamIid: self.team.id, orderId: self.order.id) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
