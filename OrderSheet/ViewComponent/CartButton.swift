//
//  CartButton.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI

struct CartButton: View {
    var font: Font = .callout
    var width: CGFloat? = 32
    var height: CGFloat? = 32
    var disabled: Bool = false
    var onTap: () -> Void = {}
    
    var body: some View {
        Button {
            self.onTap()
        } label: {
            Image(systemName: "cart")
                .foregroundColor(.white)
                .font(self.font)
                .frame(width: self.width, height: self.height, alignment: .center)
                .background(self.disabled ? Color.secondary : Color("Main"))
                .cornerRadius(50)
        }
        .disabled(self.disabled)
    }
}

struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
        CartButton()
            Button(action: {}) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color("Main"))
                    .font(.title)
            }
        }
    }
}
