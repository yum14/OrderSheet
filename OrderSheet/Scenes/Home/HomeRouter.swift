//
//  HomeRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import SwiftUI

protocol HomeWireframe {
    func makeNewTeamView(profile: Profile, onCommit: ((String) -> Void)?, onCanceled: (() -> Void)?) -> AnyView
    func makeTeamQrCodeScannerView(onFound: ((String) -> Void)?, onDismiss: (() -> Void)?) -> AnyView
    func makeTeamDetailView(profile: Profile, team: Team) -> AnyView
}

final class HomeRouter {
    static func assembleModules() -> AnyView {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        let view = HomeView(presenter: presenter)
        return AnyView(view)
    }
}

extension HomeRouter: HomeWireframe {

    func makeNewTeamView(profile: Profile, onCommit: ((String) -> Void)?, onCanceled: (() -> Void)?) -> AnyView {
        return NewTeamRouter.assembleModules(profile: profile, onCommit: onCommit, onCanceled: onCanceled)
    }
    
    func makeTeamQrCodeScannerView(onFound: ((String) -> Void)?, onDismiss: (() -> Void)?) -> AnyView {
        return TeamQrCodeScannerRouter.assembleModules(onFound: onFound, onDismiss: onDismiss)
    }
    
    func makeTeamDetailView(profile: Profile, team: Team) -> AnyView {
        return TeamDetailRouter.assembleModules(profile: profile, team: team)
    }
}
