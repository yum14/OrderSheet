//
//  CommitButton.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI

struct CommitButton: View {
    var onTap: () -> Void = {}
    
    var body: some View {
        Button(action: self.onTap, label: {
            Text("完了")
                .foregroundColor(.white)
        })
        .padding(.horizontal, 32)
        .padding(.vertical, 12)
        .background(Color("Main"))
        .cornerRadius(24)
    }
}

struct CommitButton_Previews: PreviewProvider {
    static var previews: some View {
        CommitButton()
    }
}
