//
//  PlusButton.swift
//  OrderSheet
//
//  Created by yum on 2021/09/10.
//

import SwiftUI

struct PlusButton: View {
    var font: Font = .body
    var width: CGFloat? = 24
    var height: CGFloat? = 24
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: self.onTap) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(self.font)
        }
        .frame(width: self.width, height: self.height, alignment: .center)
        .background(Color("Main"))
        .cornerRadius(50)
    }
}

struct PlusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusButton()
    }
}
