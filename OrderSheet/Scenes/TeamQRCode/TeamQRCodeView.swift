//
//  TeamQRCodeView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/24.
//

import SwiftUI

struct TeamQRCodeView: View {
    @ObservedObject var presenter: TeamQRCodePresenter
    
    var body: some View {
        VStack {
            Group {
                if let qrCode = self.presenter.qrCodeImage {
                    Image(uiImage: qrCode)
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

struct TeamQRCodeView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = TeamQRCodePresenter(teamId: UUID().uuidString)
        TeamQRCodeView(presenter: presenter)
    }
}
