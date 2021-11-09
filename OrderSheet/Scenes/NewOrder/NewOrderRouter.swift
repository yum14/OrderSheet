//
//  NewOrderRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/11/09.
//

import Foundation
import SwiftUI

final class NewOrderRouter {
    
    static func assembleModules(team: Team) -> AnyView {
        let interactor = NewOrderInteractor()
        let presenter = NewOrderPresenter(interactor: interactor, team: team)
        let view = NewOrderView(presenter: presenter)
        return AnyView(view)
    }
}
