//
//  NewOrderPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import Foundation
import SwiftUI
import Combine

final class NewOrderPresenter: ObservableObject {
    @Published var title: String
    @Published var items: [EditableListContent]
    @Published var comment: String
    @Published var showNewItem: Bool
    @Published var newItemText: String
    @Published var showingDismissConfirm = false
    
    private var interactor: NewOrderUsecase
    private var profile: Profile
    private var team: Team
    
    var commitButtonDisabled: Bool {
        return !(!self.title.isEmpty && self.items.count > 0)
    }
    
    var editing: Bool {
        return !self.title.isEmpty || !self.newItemText.isEmpty || !self.comment.isEmpty || self.items.count > 0
    }
    
    init(interactor: NewOrderUsecase,
         profile: Profile,
         team: Team) {
        self.interactor = interactor
        self.profile = profile
        self.team = team
        self.title = ""
        self.items = []
        self.comment = ""
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
    
    func createNewOrder() {
        self.interactor.addNewOrder(profile: profile,
                                    team: self.team,
                                    name: self.title,
                                    items: self.items.map { OrderItem(name: $0.text) },
                                    comment: self.comment) { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func showDismissConfirm() {
        self.showingDismissConfirm = true
    }
}
