//
//  OrderDetailRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/11/09.
//

import Foundation
import SwiftUI

final class OrderDetailRouter {
    static func assembleModules(team: Team, order: Order, owner: Profile, commitButtonTap: (() -> Void)?, editButtonTap: (() -> Void)?) -> AnyView {
        let interactor = OrderDetailInteractor()
        let presenter = OrderDetailPresenter(interactor: interactor, team: team, order: order, owner: owner, commitButtonTap: commitButtonTap, editButtonTap: editButtonTap)
        let view = OrderDetailView(presenter: presenter)
        return AnyView(view)
    }
}
