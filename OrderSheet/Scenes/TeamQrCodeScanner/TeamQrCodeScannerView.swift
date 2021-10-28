//
//  TeamQrCodeScannerView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/25.
//

import SwiftUI

struct TeamQrCodeScannerView: View {
    @ObservedObject var presenter: TeamQrCodeScannerPresenter
    
    var body: some View {
        QrCodeScannerView()
            .found(r: self.presenter.onFoundQrCode)
            .interval(delay: self.presenter.scanInterval)
        
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: self.presenter.onDismiss) {
                        Image(systemName: "xmark")
                    }
                }
            }
    }
}

struct TeamQrCodeScannerView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = TeamQrCodeScannerPresenter()
        TeamQrCodeScannerView(presenter: presenter)
    }
}
