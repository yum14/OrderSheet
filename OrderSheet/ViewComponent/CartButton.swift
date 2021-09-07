//
//  CartButton.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI

struct CartButton: View {
    var onClick: () -> Void = {}
    
    var body: some View {
        Button(action: self.onClick) {
            Image(systemName: "cart")
                .foregroundColor(.white)
                .font(.title)
        }
        .padding()
        .background(Color("Main"))
        .cornerRadius(50)
    }
}

struct CartButton_Previews: PreviewProvider {
    static var previews: some View {
        CartButton()
    }
}
