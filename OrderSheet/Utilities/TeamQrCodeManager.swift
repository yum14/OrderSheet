//
//  TeamQrCodeManager.swift
//  OrderSheet
//
//  Created by yum on 2021/09/24.
//

import Foundation
import SwiftUI

class TeamQrCodeManager {
    private let schema = "https://"
    private let domain = "icu.yum14/"
    private let path = "ordersheet/teams/"
    
    func make(teamId: String) -> UIImage? {
        if teamId.isEmpty {
            return nil
        }
        
        let url = URL(string: self.schema + self.domain + self.path + teamId)
        
        guard let data = url?.absoluteString.data(using: .utf8) else {
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
    
    func checkMyAppQrCode(code: String) -> String? {
        if code.isEmpty {
            return nil
        }
        
        guard let url = URL(string: code), let _ = url.scheme, let _ = url.host else {
            return nil
        }
        
        if !(url.pathComponents[0] == "/" && url.pathComponents[1] == "ordersheet" && url.pathComponents[2] == "teams") {
            return nil
        }
        
        return url.lastPathComponent
    }
}
