//
//  CartCheckButton.swift
//  OrderSheet
//
//  Created by yum on 2021/10/22.
//

import SwiftUI

struct CartCheckButton: View {
    var font: Font = .title
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: self.onTap) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color("Main"))
                .font(self.font)
        }
    }
}

struct CartCheckButton_Previews: PreviewProvider {
    static var previews: some View {
        CartCheckButton()
    }
}

