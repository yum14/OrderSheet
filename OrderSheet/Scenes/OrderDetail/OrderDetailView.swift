//
//  OrderDetailView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI

struct OrderDetailView: View {
    @ObservedObject var presenter: OrderDetailPresenter
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("アイテム")) {
                        
                        List {
                            ForEach(self.presenter.order.items, id: \.self) { item in
                                ZStack {
                                    HStack {
                                        Group {
                                            if item.checked {
                                                Text(item.name)
                                                .strikethrough()
                                                .foregroundColor(Color.secondary)
                                            } else {
                                                Text(item.name)
                                            }
                                        }
                                        .lineLimit(0)
                                        .foregroundColor(self.presenter.formLocked ? Color.secondary : Color.primary)
                                        
                                        Spacer()
                                        
                                        VStack {
                                            Group {
                                                if item.checked {
                                                    CheckButton(disabled: self.presenter.formLocked) { self.presenter.updateItemChecked(itemId: item.id, checked: false) }
                                                } else {
                                                    CartButton(disabled: self.presenter.formLocked) { self.presenter.updateItemChecked(itemId: item.id, checked: true) }
                                                }
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                        .frame(width: 32, height: 32, alignment: .center)
                                    }
                                }
                            }
                        }
                        .disabled(self.presenter.formLocked)
                    }
                    
                    Section(header: Text("コメント")) {
                        Text(self.presenter.order.comment ?? "")
                            .foregroundColor(self.presenter.formLocked ? Color.secondary : Color.primary)
                    }
                    
                    Section(header: Text("作成者")) {
                        Text(self.presenter.owner.displayName)
                            .foregroundColor(.secondary)
                    }
                }
                
                if self.presenter.formLocked {
                    UnlockButton {
                        self.presenter.onUnlockButtonTap()
                    }
                    .padding()
                    .alert("完了済オーダーの解除", isPresented: self.$presenter.showingUnlockConfirm) {
                        Button("キャンセル", role: .cancel) {}
                        Button("解除") {
                            self.presenter.unlock()
                            self.dismiss()
                        }
                    } message: {
                        Text("完了済オーダーを解除しますか？")
                    }
                } else {
                    CommitButton() {
                        self.presenter.commitButtonTapped()
                    }
                    .padding()
                    .alert("オーダーの完了",
                           isPresented: self.$presenter.showingOrderCommmitConfirm) {
                        Button("キャンセル", role: .cancel) {
                            
                        }
                        Button("完了") {
                            self.presenter.commit()
                        }
                    } message: {
                        Text("オーダーを完了しますか？")
                    }
                }
            }
            .navigationTitle(self.presenter.order.name)
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ViewDismissButton(onTap: { self.dismiss() })
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        
                    } label: {
                        if self.presenter.editable {
                            Button {
                                self.presenter.onEditButtonTap()
                            } label: {
                                Text("編集")
                            }
                        }
                    }

                }
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order(name: "オーダー1",
                          items: [OrderItem(name: "たまねぎ", checked: true),
                                  OrderItem(name: "にんじん"),
                                  OrderItem(name: "トイレットペーパー")],
                          owner: "owner")
        let team = Team(name: "team", members: [], owner: "owner")
        let interactor = OrderDetailInteractor()
        let presenter = OrderDetailPresenter(interactor: interactor,
                                             team: team,
                                             order: order,
                                             owner: Profile(id: "owner", displayName: "オーナー", teams: []),
                                             commitButtonTap: {}, editButtonTap: {})
        
        OrderDetailView(presenter: presenter)
    }
}
