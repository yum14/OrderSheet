//
//  NewTeamPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/21.
//

import Foundation
import SwiftUI
import Combine

final class NewTeamPresenter: ObservableObject {
    @Published var text: String
    private var onCommit: (String) -> Void = { _ in }
    private var onCanceled: () -> Void = {}
    
    init(onCommit: @escaping (String) -> Void = { _ in }, onCanceled: @escaping () -> Void = {}) {
        self.text = ""
        self.onCommit = onCommit
        self.onCanceled = onCanceled
    }
    
    func inputCommit() -> Void {
        self.onCommit(self.text)
    }
    
    func inputCancel() -> Void {
        self.onCanceled()
    }
}
