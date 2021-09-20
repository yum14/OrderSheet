//
//  RemoveButton.swift
//  OrderSheet
//
//  Created by yum on 2021/09/10.
//

import SwiftUI

struct RemoveButton: View {
    var backgroundColor: Color = Color("Main")
    var disabledBackgroundColor: Color = .gray
    var font: Font = .body
    var width: CGFloat? = 24
    var height: CGFloat? = 24
    var disabled: Bool = false
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: self.onTap) {
            Image(systemName: "minus")
                .foregroundColor(.white)
                .font(self.font)
                .frame(width: self.width, height: self.height, alignment: .center)
                .background(self.disabled ? self.disabledBackgroundColor : self.backgroundColor)
                .cornerRadius(50)
        }
        .disabled(self.disabled)
    }
}

struct RemoveButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            RemoveButton()
        }
    }
}
