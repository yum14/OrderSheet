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
            
            Section(header: Text("アイテム"),
                    footer:
                        HStack {
                            Spacer()
                            AddButton(disabled: self.presenter.addItemButtonDisabled) {
                                self.presenter.addItem()
                            }
                        }) {
                
                EditableList(contents: self.$presenter.items)
                
                if self.presenter.showNewItem {
                    CustomTextField("新しいアイテム", text: self.$presenter.newItemText, isFirstResponder: true, onCommit: self.presenter.commitNewItemInput)
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
