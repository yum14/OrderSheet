//
//  LoginRouter.swift
//  OrderSheet
//
//  Created by yum on 2021/11/09.
//

import Foundation
import SwiftUI

final class LoginRouter {
    
    static let presenter = LoginPresenter()
    
    static func assembleModules() -> AnyView {
        let view = LoginView(presenter: presenter)
        return AnyView(view)
    }
}
