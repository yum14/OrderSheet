//
//  OrderEditRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/11/09.
//

import Foundation
import SwiftUI

final class OrderEditRouter {
    static func assembleModules(profile: Profile, team: Team, order: Order) -> AnyView {
        let interactor = OrderEditInteractor()
        let presenter = OrderEditPresenter(interactor: interactor, profile: profile, team: team, order: order)
        let view = OrderEditView(presenter: presenter)
        return AnyView(view)
    }
}
