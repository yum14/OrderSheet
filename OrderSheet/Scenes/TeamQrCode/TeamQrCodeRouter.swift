//
//  TeamQrCodeRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/11/09.
//

import Foundation
import SwiftUI

final class TeamQrCodeRouter {
    static func assembleModules(teamId: String) -> AnyView {
        let presenter = TeamQrCodePresenter(teamId: teamId)
        let view = TeamQrCodeView(presenter: presenter)
        return AnyView(view)
    }
}
