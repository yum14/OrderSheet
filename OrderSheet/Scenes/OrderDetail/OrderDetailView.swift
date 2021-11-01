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
                                        Text(item.name)
                                            .lineLimit(0)
                                        Spacer()
                                        
                                        VStack {
                                            Group {
                                                if item.checked {
                                                    CartCheckButton(onTap: { self.presenter.updateItemChecked(itemId: item.id, checked: false) })
                                                } else {
                                                    CartButton(onTap: { self.presenter.updateItemChecked(itemId: item.id, checked: true) })
                                                }
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                        .frame(width: 32, height: 32, alignment: .center)
                                    }
                                }
                            }
                        }
                    }
                    
                    Section(header: Text("コメント")) {
                        Text(self.presenter.order.comment ?? "")
                    }
                }
                
                CommitButton(onTap: self.presenter.commitButtonTapped)
                    .padding()
            }
            .navigationTitle(self.presenter.order.name)
            .navigationViewStyle(StackNavigationViewStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
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
            .alert("オーダーの完了",
                   isPresented: self.$presenter.showingOrderCommmitConfirm) {
                Button("キャンセル", role: .cancel) {
                    
                }
                Button("OK") {
                    self.presenter.commit()
                }
            } message: {
                Text("オーダーを完了しますか？")
            }
        }
    }
}

struct OrderView_Previews: PreviewProvider {
    static var previews: some View {
        let order = Order(name: "オーダー1",
                          items: [OrderItem(name: "たまねぎ", checked: true),
                                  OrderItem(name: "にんじん"),
                                  OrderItem(name: "トイレットペーパー")])
        let team = Team(name: "team", members: [], owner: "owner")
        let interactor = OrderDetailInteractor()
        let presenter = OrderDetailPresenter(interactor: interactor, team: team, order: order, commitButtonTap: {}, editButtonTap: {})
        
        OrderDetailView(presenter: presenter)
    }
}
