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
    
    var body: some View {
        if self.authStateObserver.isSignedIn {
            TabView {
                self.presenter.makeAboutHomeView()
                    .tabItem {
                        Image(systemName: "house")
                    }
                
                self.presenter.makeAboutOrderListView()
                    .tabItem {
                        Image(systemName: "list.bullet.rectangle")
                    }
            }
            
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
