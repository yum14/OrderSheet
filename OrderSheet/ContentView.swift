//
//  ContentView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI

struct ContentView: View {
    @StateObject var presenter = RootPresenter()
    
    var body: some View {
        RootView(presenter: presenter)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
