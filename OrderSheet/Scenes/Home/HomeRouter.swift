//
//  HomeRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import Foundation
import SwiftUI

final class HomeRouter {
    
    func makeNewTeamView(user: User,
                         onCommit: @escaping (String) -> Void = { _ in },
                         onCanceled: @escaping () -> Void = {}) -> some View {
        
        let store = TeamStore()
        let interactor = NewTeamInteractor(store: store)
        let presenter = NewTeamPresenter(interactor: interactor,
                                         user: user,
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
    
    func makeTeamDetailView(team: Team, members: [User]) -> some View {
        let presenter = TeamDetailPresenter(team: team, members: members)
        let view = TeamDetailView(presenter: presenter)
        return view
    }
}
