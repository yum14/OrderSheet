//
//  TeamQrCodePresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/24.
//

import Foundation
import SwiftUI
import Combine

final class TeamQrCodePresenter: ObservableObject {
    @Published var QrCodeImage: UIImage?
    let qrCodeManager = TeamQrCodeManager()
    
    init(teamId: String) {
        DispatchQueue.main.async {
            self.QrCodeImage = self.qrCodeManager.make(teamId: teamId)
        }
    }
}
