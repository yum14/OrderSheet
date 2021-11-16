//
//  HomeRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import SwiftUI

protocol HomeWireframe {
    func makeNewTeamView(onCommit: ((String) -> Void)?, onCanceled: (() -> Void)?) -> AnyView
    func makeTeamQrCodeScannerView(onFound: ((String) -> Void)?, onDismiss: (() -> Void)?) -> AnyView
    func makeTeamDetailView(team: Team) -> AnyView
}

final class HomeRouter {

    static let interactor = HomeInteractor()
    static let router = HomeRouter()
    static let presenter = HomePresenter(interactor: interactor, router: router)
    
    static func assembleModules() -> AnyView {
        let view = HomeView(presenter: presenter)
        return AnyView(view)
    }
}

extension HomeRouter: HomeWireframe {

    func makeNewTeamView(onCommit: ((String) -> Void)?, onCanceled: (() -> Void)?) -> AnyView {
        return NewTeamRouter.assembleModules(onCommit: onCommit, onCanceled: onCanceled)
    }
    
    func makeTeamQrCodeScannerView(onFound: ((String) -> Void)?, onDismiss: (() -> Void)?) -> AnyView {
        return TeamQrCodeScannerRouter.assembleModules(onFound: onFound, onDismiss: onDismiss)
    }
    
    func makeTeamDetailView(team: Team) -> AnyView {
        return TeamDetailRouter.assembleModules(team: team)
    }
}
