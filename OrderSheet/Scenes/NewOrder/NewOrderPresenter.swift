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
    @Published var name: String
    @Published var items: [EditableListContent]
    @Published var comment: String
    @Published var showNewItem: Bool
    @Published var newItemText: String
    
    init() {
        self.title = ""
        self.name = ""
        self.items = []
        self.comment = ""
        
        self.items = [EditableListContent(text: "アイウエオ"),
                      EditableListContent(text: "かきくけこ")]
        
        self.showNewItem = false
        self.newItemText = ""
    }
    
    func addItem() {
//        self.items.append(EditableListContent(text: ""))
        self.showNewItem = true
    }
    
    func commitNewItemInput() {
        if !self.newItemText.isEmpty {
            self.items.append(EditableListContent(text: self.newItemText))
        }
        
        self.showNewItem = false
        self.newItemText = ""
    }
    
    var addItemButtonDisabled: Bool {
        return self.showNewItem
    }
}