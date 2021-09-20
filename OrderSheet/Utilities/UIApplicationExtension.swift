//
//  UIApplicationExtension.swift
//  OrderSheet
//
//  Created by yum on 2021/09/19.
//

import SwiftUI

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
