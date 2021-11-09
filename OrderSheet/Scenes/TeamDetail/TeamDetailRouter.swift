//
//  TeamDetailRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/26.
//

import Foundation
import SwiftUI

protocol TeamDetailWireframe {
    func makeLoginView() -> AnyView
    func makeTeamQrCodeView(teamId: String) -> AnyView
}

final class TeamDetailRouter {
    
    static func assembleModules(teamId: String) -> AnyView {
        let interactor = TeamDetailInteractor()
        let router = TeamDetailRouter()
        let presenter = TeamDetailPresenter(interactor: interactor, router: router, teamId: teamId)
        let view = TeamDetailView(presenter: presenter)
        return AnyView(view)
    }
}

extension TeamDetailRouter: TeamDetailWireframe {

    func makeLoginView() -> AnyView {
        return LoginRouter.assembleModules()
    }
    
    func makeTeamQrCodeView(teamId: String) -> AnyView {
        return TeamQrCodeRouter.assembleModules(teamId: teamId)
    }
}
