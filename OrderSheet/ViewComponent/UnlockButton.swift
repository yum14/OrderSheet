//
//  UnlockButton.swift
//  OrderSheet
//
//  Created by yum on 2021/10/26.
//

import SwiftUI

struct UnlockButton: View {
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: self.onTap) {
            Text("解除")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 260, height: 40)
                .background(Color("Main"))
                .cornerRadius(24)
        }
    }
}

struct UnlockButton_Previews: PreviewProvider {
    static var previews: some View {
        UnlockButton()
    }
}
