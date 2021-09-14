//
//  RootPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI

class RootPresenter: ObservableObject {
    private let router = RootRouter()
    
    func makeAboutLoginView() -> some View {
        router.makeLoginView()
    }
    
    func makeAboutOrderListView() -> some View {
        router.makeOrderListView()
    }
}
