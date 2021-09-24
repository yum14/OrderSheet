//
//  QRCodeMaker.swift
//  OrderSheet
//
//  Created by yum on 2021/09/24.
//

import Foundation
import SwiftUI

class QRCodeMaker {
    static func make(message:String) -> UIImage? {
        guard let data = message.data(using: .utf8) else {
            return nil
        }

        // 誤り訂正レベルはとりあえずQを指定
        guard let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": data, "inputCorrectionLevel": "Q"]) else {
            return nil
        }

        // 元のCIImageは小さいので任意のサイズに拡大
        let sizeTransform = CGAffineTransform(scaleX: 8, y: 8)

        guard let ciImage = qr.outputImage?.transformed(by: sizeTransform) else {
            return nil
        }

        // CIImageをそのまま変換するとImageで表示されないため一度CGImageに変換してからUIImageに変換する
        guard let cgImage = CIContext().createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }

        let image = UIImage(cgImage: cgImage)

        return image
    }
}
