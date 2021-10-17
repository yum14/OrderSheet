//
//  QrCodeScannerBanner.swift
//  OrderSheet
//
//  Created by yum on 2021/10/17.
//

import SwiftUI

struct QrCodeScannerBanner: View {
    var body: some View {
        HStack(spacing: 10) {
            VStack(spacing: 8) {
                Text("有効なチームではありません")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 200, height: 60)
        .background(Color(UIColor(hex: "293241")))
        .cornerRadius(30.0)
    }
}

struct QrCodeScannerBanner_Previews: PreviewProvider {
    static var previews: some View {
        QrCodeScannerBanner()
    }
}
