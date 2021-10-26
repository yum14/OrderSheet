//
//  OrderListView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/09.
//

import SwiftUI
import GoogleSignIn
import PopupView

struct OrderListView: View {
    @ObservedObject var presenter: OrderListPresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    @State var showing = false
    
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    if self.presenter.popupPresented {
                        Color.black.opacity(0.3)
                            .edgesIgnoringSafeArea(.all)
                            .transition(.opacity)
                            .zIndex(1)
                    }
                    
                    VStack {
                        OrderList(orders: self.presenter.orders,
                                  onRowTap: { order in
                            self.presenter.showOrderDetailSheet(id: order.id)
                        },
                                  onUnlockButtonTap: { order in self.presenter.unlockButtonTapped(id: order.id)
                        })
                    }
                    .sheet(isPresented: self.$presenter.sheetPresented) {
                        if let sheetType = self.presenter.sheetType, sheetType == .OrderDetail {
                            self.presenter.makeAboutOrderDetailSheetView()
                        } else {
                            self.presenter.makeAboutNewOrderSheetView()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(leading:
                                        Text(self.presenter.selectedTeam?.name ?? "")
                                        .onTapGesture {
                    self.presenter.popupPresented.toggle()
                },
                                    trailing: Button(action: self.presenter.showNewOrderSheet) {
                    Image(systemName: "plus")
                })
            }
            .popup(isPresented: self.$presenter.popupPresented,
                   type: .default,
                   position: .top,
                   animation: .spring(),
                   closeOnTap: false,
                   closeOnTapOutside: true,
                   dismissCallback: {
                
                if let user = self.authStateObserver.appUser {
                    self.presenter.updateSelectedTeam(uid: user.id)
                }
            }) {
                TeamSelectList(teams: self.presenter.teams,
                               selectedTeam: self.$presenter.selectedTeam,
                               onTeamSelected: self.presenter.teamSelected)
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    .frame(width: 350)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(10.0)
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
            }
            
            .alert("オーダー完了済の解除", isPresented: self.$presenter.showingUnlockConfirm) {
                Button("キャンセル", role: .cancel) {
                    self.presenter.unlockCancel()
                }
                Button("解除") {
                    self.presenter.unlock()
                }
            } message: {
                Text("オーダー完了済を解除しますか？")
            }

        }
        .onAppear {
            if let user = self.authStateObserver.appUser {
                self.presenter.load(user: user)
            }
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        let template = "yyyy/MM/dd HH:mm:ss"
        
        let products = [OrderItem(name: "たまねぎ"),
                        OrderItem(name: "にんじん"),
                        OrderItem(name: "トイレットペーパー")]
        
        let orders = [Order(name: "オーダー1", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", items: products, createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))]
        let teams = [Team(name: "A", members: [], owner: ""),
                     Team(name: "B", members: [], owner: ""),
                     Team(name: "C", members: [], owner: "")]
        
        let interactor = OrderListInteractor()
        let router = OrderListRouter()
        let presenter = OrderListPresenter(interactor: interactor, router: router, orders: orders, teams: teams)
        let authStateObserver = AuthStateObserver()
        
        VStack {
            OrderListView(presenter: presenter)
                .environmentObject(authStateObserver)
        }
    }
}
