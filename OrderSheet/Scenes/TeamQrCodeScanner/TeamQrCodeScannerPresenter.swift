//
//  TeamQrCodeScannerPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/25.
//

import Foundation
import SwiftUI
import Combine

final class TeamQrCodeScannerPresenter: ObservableObject {
    let scanInterval: Double = 1.0
    @Published var lastQrCode: String = ""
    var onFound: (String) -> Void = { _ in }
    var onDismiss: () -> Void = {}
    
    init(onFound: @escaping (String) -> Void = { _ in }, onDismiss: @escaping () -> Void = {}) {
        self.onFound = onFound
        self.onDismiss = onDismiss
    }
    
    func onFoundQrCode(_ code: String) {
        self.lastQrCode = code
        self.onFound(code)
    }
}
