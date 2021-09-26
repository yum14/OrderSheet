//
//  TeamDetailRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/26.
//

import Foundation
import SwiftUI

final class TeamDetailRouter {
    func makeLoginView() -> some View {
        let presenter = LoginPresenter()
        let view = LoginView(presenter: presenter)
        return view
    }
    
    func makeTeamQRCodeView(teamId: String) -> some View {
        let presenter = TeamQrCodePresenter(teamId: teamId)
        let view = TeamQrCodeView(presenter: presenter)
        return view
    }
}
