//
//  PlusButton.swift
//  OrderSheet
//
//  Created by yum on 2021/12/27.
//

import SwiftUI

struct PlusButton: View {
    var onTap: (() -> Void)?
    
    var body: some View {
        
        Button {
            onTap?()
        } label: {
            Circle()
                .fill(Color("Main"))
                .frame(width: 60, height: 60, alignment: .center)
                .shadow(color: Color.black.opacity(0.3),
                        radius: 5,
                        x: 3,
                        y: 3)
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(.white)
                        .font(.title)
                )

        }
    }
}

struct PlusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusButton()
    }
}
