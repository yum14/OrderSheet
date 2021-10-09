//
//  HomeRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import SwiftUI

final class HomeRouter {
    
//    let newTeamInteractor: NewTeamUsecase
//    let newTeamPresenter: NewTeamPresenter
//    let teamQrCodeScannerPresenter: TeamQrCodeScannerPresenter
//    let teamDetailRouter: TeamDetailRouter
//    let teamDetailInteractor: TeamDetailUsecase
//    let teamDetailPresenter: TeamDetailPresenter
    
    
    
    func makeNewTeamView(onCommit: @escaping (String) -> Void = { _ in },
                         onCanceled: @escaping () -> Void = {}) -> some View {
        
        let interactor = NewTeamInteractor()
        let presenter = NewTeamPresenter(interactor: interactor,
                                         onCommit: onCommit,
                                         onCanceled: onCanceled)
        return NewTeamView(presenter: presenter)
    }
    
    func makeTeamQrCodeScannerView(onFound: @escaping (String) -> Void, onDismiss: @escaping () -> Void) -> some View {
        
        let presenter = TeamQrCodeScannerPresenter(
            onFound: onFound,
            onDismiss: onDismiss)
        return TeamQrCodeScannerView(presenter: presenter)
    }
    
    func makeTeamDetailView(id: String) -> some View {
        let router = TeamDetailRouter()
        let interactor = TeamDetailInteractor()
        let presenter = TeamDetailPresenter(interactor: interactor, router: router, teamId: id)
        let view = TeamDetailView(presenter: presenter)
        return view
    }
}
