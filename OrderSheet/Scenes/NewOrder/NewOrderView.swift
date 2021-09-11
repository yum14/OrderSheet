//
//  NewOrderView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI

struct NewOrderView: View {
    @ObservedObject var presenter: NewOrderPresenter
    
    var body: some View {
        Form {
            Section(header: Text("タイトル")) {
                TextField("新しいオーダー", text: self.$presenter.title)
            }
            
            Section(header: Text("アイテム")) {
                HStack {
                    TextField("", text: self.$presenter.name)
                    PlusButton(onTap: {})
                }
                HStack {
                    TextField("", text: self.$presenter.name)
                    PlusButton(onTap: {})
                }
                HStack {
                    TextField("", text: self.$presenter.name)
                    PlusButton(onTap: {})
                }
            }
            
            Section(header: Text("コメント")) {
                TextField("コメント", text: self.$presenter.comment)
            }
        }
        .navigationTitle("新しいオーダー")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct NewOrderView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = NewOrderPresenter()
        
        NavigationView {
            NewOrderView(presenter: presenter)
        }
    }
}
