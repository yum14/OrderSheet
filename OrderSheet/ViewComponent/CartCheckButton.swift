//
//  CartCheckButton.swift
//  OrderSheet
//
//  Created by yum on 2021/10/22.
//

import SwiftUI

struct CartCheckButton: View {
    var font: Font = .title
    var disabled: Bool = false
    var onTap: () -> Void = {}
    
    var body: some View {
        Button {
            self.onTap()
        } label: {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(self.disabled ? Color.secondary : Color("Main"))
                .font(self.font)
        }
        .disabled(self.disabled)
    }
}

struct CartCheckButton_Previews: PreviewProvider {
    static var previews: some View {
        CartCheckButton()
    }
}

