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
    @Published var items: [Product]
    @Published var comment: String
    
    init() {
        self.title = ""
        self.name = ""
        self.items = []
        self.comment = ""
    }
}
