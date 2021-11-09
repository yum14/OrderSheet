//
//  TeamQrCodeScannerRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/11/09.
//

import Foundation
import SwiftUI

final class TeamQrCodeScannerRouter {
    static func assembleModules(onFound: ((String) -> Void)?, onDismiss: (() -> Void)?) -> AnyView {
        let presenter = TeamQrCodeScannerPresenter(onFound: onFound, onDismiss: onDismiss)
        let view = TeamQrCodeScannerView(presenter: presenter)
        return AnyView(view)
    }
}

