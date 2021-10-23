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
    var commitButtonTap: () -> Void = {}
    
    private var team: Team
    private var interactor: OrderDetailUsecase
    
    init(interactor: OrderDetailUsecase, team: Team, order: Order, commitButtonTap: @escaping () -> Void = {}) {
        self.order = order
        self.team = team
        self.commitButtonTap = commitButtonTap
        self.interactor = interactor
    }
    
    func updateItemChecked(checked: Bool) {
        self.interactor.updateItemChecked(teamId: self.team.id, id: self.order.id, checked: checked) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
