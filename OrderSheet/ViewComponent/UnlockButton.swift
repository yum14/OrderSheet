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
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 56, height: 28)
                .background(Color("Main"))
                .cornerRadius(50)
        }
    }
}

struct UnlockButton_Previews: PreviewProvider {
    static var previews: some View {
        UnlockButton()
    }
}
