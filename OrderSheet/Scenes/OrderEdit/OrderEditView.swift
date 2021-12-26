//
//  OrderEditView.swift
//  OrderSheet
//
//  Created by yum on 2021/10/30.
//

import SwiftUI

struct OrderEditView: View {
    @ObservedObject var presenter: OrderEditPresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("タイトル")) {
                    TextField("オーダー", text: self.$presenter.title)
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
                
                Section(header: Text("作成者")) {
                    Text(self.presenter.createUser?.displayName ?? "")
                }
                
                Section {
                    Button {
                        self.presenter.updateOrder()
                        dismiss()
                    } label: {
                        HStack {
                            Spacer()
                            Text("保存して閉じる")
                            Spacer()
                        }
                    }
                    .disabled(self.presenter.saveButtonDisabled)
                    
                    Button(role: .destructive) {
                        self.presenter.showDeleteOrderConfirm()
                    } label: {
                        HStack {
                            Spacer()
                            Text("オーダーを削除する")
                            Spacer()
                        }
                    }
                    .disabled(self.presenter.orderDeleteDisabled(loginUserId: self.authStateObserver.appUser!.id))
                    .alert("オーダーの削除",
                           isPresented: self.$presenter.showingDeleteOrderConfirm) {
                        Button(role: .cancel) {

                        } label: {
                            Text("キャンセル")
                        }

                        Button(role: .destructive) {
                            self.presenter.deleteOrder()
                            self.dismiss()
                        } label: {
                            Text("削除する")
                        }
                    } message: {
                        Text("オーダーを削除しますか？")
                    }
                }
            }
            .onAppear {
                self.presenter.load()
            }
            .navigationTitle("オーダーの編集")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ViewDismissButton(onTap: { self.dismiss() })
                }
            }
        }
    }
}

struct OrderEditView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order(name: "オーダー1",
                          items: [OrderItem(name: "たまねぎ", checked: true),
                                  OrderItem(name: "にんじん"),
                                  OrderItem(name: "トイレットペーパー")],
                          owner: "owner")
        let team = Team(name: "team", members: [], owner: "owner")
        let interactor = OrderEditInteractor()
        let presenter = OrderEditPresenter(interactor: interactor, team: team, order: order)
        
        NavigationView {
            OrderEditView(presenter: presenter)
        }
    }
}
