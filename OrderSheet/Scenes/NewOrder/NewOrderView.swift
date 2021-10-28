//
//  NewOrderView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI

struct NewOrderView: View {
    @ObservedObject var presenter: NewOrderPresenter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("タイトル")) {
                    TextField("新しいオーダー", text: self.$presenter.title)
                }
                
                Section(header: Text("アイテム"),
                        footer:
                            HStack(spacing: 0) {
                    Spacer()
                    AddButton(disabled: self.presenter.addItemButtonDisabled) {
                        self.presenter.addItem()
                    }
                }) {
                    
                    EditableList(contents: self.$presenter.items)
                    
                    if self.presenter.items.count == 0 {
                        TextField("新しいアイテム", text: self.$presenter.newItemText, onCommit: self.presenter.commitNewItemInput)
                    } else {
                        if self.presenter.showNewItem {
                            CustomTextField("新しいアイテム", text: self.$presenter.newItemText, isFirstResponder: true, onCommit: self.presenter.commitNewItemInput)
                        }
                    }
                }
                
                Section(header: Text("コメント")) {
                    TextField("コメント", text: self.$presenter.comment)
                }
                
                Section {
                    Button(action: {
                        self.presenter.createNewOrder()
                        dismiss()
                    }) {
                        HStack {
                            Spacer()
                            Text("作成")
                            Spacer()
                        }
                    }
                    .disabled(self.presenter.commitButtonDisabled)
                }
            }
            
            .actionSheet(isPresented: self.$presenter.showingDismissConfirm) {
                ActionSheet(title: Text(""),
                            message: Text("編集内容を破棄しますか？"),
                            buttons: [
                                .destructive(Text("破棄する")) {
                                    self.dismiss()
                                },
                                .cancel()
                            ])
            }
            .navigationTitle("新しいオーダー")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if self.presenter.editing {
                            self.presenter.showDismissConfirm()
                        } else {
                            self.dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct NewOrderView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = NewOrderInteractor()
        let presenter = NewOrderPresenter(interactor: interactor, team: Team(name: "チーム", members: [], owner: "owner"))
        
        NavigationView {
            NewOrderView(presenter: presenter)
        }
    }
}
