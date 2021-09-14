//
//  ContentView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        RootView(presenter: RootPresenter())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
