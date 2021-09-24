//
//  TeamQRCodePresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/24.
//

import Foundation
import SwiftUI
import Combine

final class TeamQRCodePresenter: ObservableObject {
    @Published var qrCodeImage: UIImage?
    
    init(teamId: String) {
        DispatchQueue.main.async {
            self.qrCodeImage = QRCodeMaker.make(message: teamId)
        }
    }
}
