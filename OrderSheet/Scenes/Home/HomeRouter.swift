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
    func makeTeamDetailView(teamId: String) -> AnyView
}

final class HomeRouter {
    
//    let newTeamInteractor: NewTeamUsecase
//    let newTeamPresenter: NewTeamPresenter
//    let teamQrCodeScannerPresenter: TeamQrCodeScannerPresenter
//    let teamDetailRouter: TeamDetailRouter
//    let teamDetailInteractor: TeamDetailUsecase
//    let teamDetailPresenter: TeamDetailPresenter
    
    static func assembleModules() -> AnyView {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
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
    
    func makeTeamDetailView(teamId: String) -> AnyView {
        return TeamDetailRouter.assembleModules(teamId: teamId)
    }
}
