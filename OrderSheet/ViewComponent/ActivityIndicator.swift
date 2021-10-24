//
//  ActivityIndicator.swift
//  OrderSheet
//
//  Created by yum on 2021/10/24.
//

import SwiftUI
import ActivityIndicatorView

struct ActivityIndicator: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        ActivityIndicatorView(isVisible: self.$isVisible,
                              type: .default)
            .frame(width: 50.0, height: 50.0)
            .foregroundColor(Color("Main"))
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicator(isVisible: .constant(true))
    }
}
