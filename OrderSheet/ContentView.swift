//
//  ContentView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI

struct ContentView: View {
    @StateObject var rootPresenter = RootPresenter()
    
    var body: some View {
        RootView(rootPresenter: rootPresenter)            
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
