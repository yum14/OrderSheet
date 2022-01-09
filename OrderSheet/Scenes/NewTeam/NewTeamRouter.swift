//
//  NewTeamRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/11/09.
//

import Foundation
import SwiftUI

final class NewTeamRouter {
    static func assembleModules(profile: Profile, onCommit: ((String) -> Void)?, onCanceled: (() -> Void)?) -> AnyView {
        let interactor = NewTeamInteractor()
        let presenter = NewTeamPresenter(interactor: interactor, profile: profile, onCommit: onCommit, onCanceled: onCanceled)
        let view = NewTeamView(presenter: presenter)
        return AnyView(view)
    }
}
