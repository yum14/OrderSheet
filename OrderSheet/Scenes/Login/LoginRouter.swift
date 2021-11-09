//
//  LoginRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/11/09.
//

import Foundation
import SwiftUI

final class LoginRouter {
    
    static func assembleModules() -> AnyView {
        let presenter = LoginPresenter()
        let view = LoginView(presenter: presenter)
        return AnyView(view)
    }
}
