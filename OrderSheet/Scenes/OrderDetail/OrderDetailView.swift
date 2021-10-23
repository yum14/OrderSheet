//
//  OrderDetailView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI

struct OrderDetailView: View {
    @ObservedObject var presenter: OrderDetailPresenter
    
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
                                                    CartCheckButton(onTap: { self.presenter.updateItemChecked(checked: false) })
                                                } else {
                                                    CartButton(onTap: { self.presenter.updateItemChecked(checked: true) })
                                                }
                                            }
                                            .buttonStyle(BorderlessButtonStyle())
                                        }
                                        .frame(width: 32, height: 32, alignment: .center)
//                                        .background(Color.blue)
                                    }
                                }
                            }
                        }
                        
//                        ProductList(products: self.presenter.order.items,
//                                    onListItemTap: { _ in },
//                                    onCartButtonTap: { _ in })
                    }
                    
                    Section(header: Text("コメント")) {
                        Text(self.presenter.order.comment ?? "")
                    }
                }
                
                
                HStack {
                    Spacer()
                    CommitButton(onTap: self.presenter.commitButtonTap)
                        .padding()
                }
            }
            .navigationTitle(self.presenter.order.name)
            .navigationViewStyle(StackNavigationViewStyle())
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
        let presenter = OrderDetailPresenter(interactor: interactor, team: team, order: order)
        
        OrderDetailView(presenter: presenter)
    }
}
