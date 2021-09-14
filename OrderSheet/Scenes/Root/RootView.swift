//
//  RootView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var presenter: RootPresenter
    @EnvironmentObject var authState: AuthState
    
    var body: some View {
        if self.authState.isSignedIn {
            self.presenter.makeAboutOrderListView()
        } else {
            self.presenter.makeAboutLoginView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = RootPresenter()
        RootView(presenter: presenter)
    }
}
