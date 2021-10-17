//
//  RootView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var rootPresenter: RootPresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    
    var body: some View {
        if self.authStateObserver.isSignedIn == true {
            ZStack {
                TabView {
                    self.rootPresenter.makeAboutHomeView()
                        .tabItem {
                            Image(systemName: "house")
                        }
                    
                    self.rootPresenter.makeAboutOrderListView()
                        .tabItem {
                            Image(systemName: "list.bullet.rectangle")
                        }
                }
            }
        } else {
            self.rootPresenter.makeAboutLoginView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        let rootPresenter = RootPresenter()
        RootView(rootPresenter: rootPresenter)
    }
}
