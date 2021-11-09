//
//  RootView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var presenter: RootPresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    @State var tabSelection: Int = 1
    
    var body: some View {
        if self.authStateObserver.isSignedIn == true {
            TabView(selection: self.$tabSelection) {
                self.presenter.makeAboutHomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                    .tag(0)
                
                self.presenter.makeAboutOrderListView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                    }
                    .tag(1)
            }
        } else {
            self.presenter.makeAboutLoginView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = RootPresenter(router: RootRouter())
        RootView(presenter: presenter)
    }
}
