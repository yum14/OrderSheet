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
    
    var body: some View {
        ZStack {
            if self.presenter.showingTeamSelectPopup {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .zIndex(1)
            }
            
            NavigationView {
                
                ZStack {
                    
                    if self.presenter.selectedTeam == nil {
                        VStack {
                            Text("チームに参加、")
                                .foregroundColor(Color.secondary)
                            Text("または新たにチームを作成しましょう。")
                                .foregroundColor(Color.secondary)
                        }
                    }
                    else if !(self.presenter.orders.count > 0) {
                        Text("オーダーを作成しましょう。")
                            .foregroundColor(Color.secondary)
                    } else {
                        OrderList(orders: self.presenter.orders) { order in
                            self.presenter.showOrderDetailSheet(id: order.id)
                        }
                    }
                    
                    if self.presenter.selectedTeam != nil {
                        // ZStackのalignment指定だと初期ロード時に中央に配置されてしまうので、Spacerによって右下よせとする
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                PlusButton(onTap: self.presenter.showNewOrderSheet)
                                    .padding()
                            }
                        }
                    }
                }
                .sheet(isPresented: self.$presenter.showingOrderDetailOrEdit) {
                    if self.presenter.sheetType == .edit {
                        self.presenter.makeAboutOrderEditSheetView()
                    } else {
                        self.presenter.makeAboutOrderDetailSheetView()
                    }
                }
                .fullScreenCover(isPresented: self.$presenter.showingNewOrder) {
                    self.presenter.makeAboutNewOrderSheetView()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            self.presenter.showingTeamSelectPopup = true
                        } label: {
                            if let teams = self.presenter.teams, teams.count > 0 {
                                HStack {
                                    AvatarImage(image: self.presenter.selectedTeam?.avatarImage != nil ? UIImage(data: self.presenter.selectedTeam!.avatarImage!) : nil, defaultImageName: "person.2.circle.fill", length: 28)
                                    Text(self.presenter.selectedTeam?.name ?? "")
                                        .foregroundColor(Color.primary)
                                        .lineLimit(1)
                                    
                                    Image(systemName: "chevron.down")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                            }
                        }
                        .disabled(self.presenter.toolbarItemDisabled)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            if let user = self.authStateObserver.appUser {
                self.presenter.load(user: user)
            }
        }
        .popup(isPresented: self.$presenter.showingTeamSelectPopup,
               type: .floater(verticalPadding: 100),
               position: .top,
               animation: .spring(),
               closeOnTap: false,
               closeOnTapOutside: true,
               dismissCallback: {}) {
            
            TeamSelectList(teams: self.presenter.teams,
                           selectedTeam: self.$presenter.selectedTeam,
                           onTeamSelected: { team in
                self.presenter.teamSelected(user: self.authStateObserver.appUser!, team: team)
            })
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                .frame(width: 350)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10.0)
                .shadow(color: Color(.sRGBLinear, white: 0, opacity: 0.13), radius: 10.0)
        }
    }
}

struct OrderListView_Previews: PreviewProvider {
    static var previews: some View {
        let template = "yyyy/MM/dd HH:mm:ss"
        
        let products = [OrderItem(name: "たまねぎ"),
                        OrderItem(name: "にんじん"),
                        OrderItem(name: "トイレットペーパー")]
        
        let orders = [Order(name: "オーダー1", items: products, owner: "owner", createdAt: DateUtility.toDate(dateString: "2021/01/01 01:00:00", template: template)),
                      Order(name: "オーダー2", items: products, owner: "owner", createdAt: DateUtility.toDate(dateString: "2021/01/01 12:00:00", template: template)),
                      Order(name: "オーダー3", items: products, owner: "owner", createdAt: DateUtility.toDate(dateString: "2021/01/02 01:00:00", template: template))]
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
