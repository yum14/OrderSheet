//
//  TeamQrCodeView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/24.
//

import SwiftUI

struct TeamQrCodeView: View {
    @ObservedObject var presenter: TeamQrCodePresenter
    
    var body: some View {
        VStack {
            Group {
                if let QrCode = self.presenter.QrCodeImage {
                    Image(uiImage: QrCode)
                } else {
                    Text("Loading...")
                        .frame(height: 248)
                }
            }
            
            HStack {
                Text("このQRコードをスキャンすると、チームに参加できます。")
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
            }
        }
    }
}

struct TeamQrCodeView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = TeamQrCodePresenter(teamId: UUID().uuidString)
        TeamQrCodeView(presenter: presenter)
    }
}
