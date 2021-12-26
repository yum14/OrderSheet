//
//  ViewDismissButton.swift
//  OrderSheet
//
//  Created by yum on 2021/12/25.
//

import SwiftUI

struct ViewDismissButton: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        Button {
            self.onTap?()
        } label: {
            Image(systemName: "xmark")
        }
    }
}

struct ViewDismissButton_Previews: PreviewProvider {
    static var previews: some View {
        ViewDismissButton()
    }
}
