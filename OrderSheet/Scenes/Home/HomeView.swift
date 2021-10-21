//
//  HomeView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import SwiftUI
import PopupView

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Circle()
                        .frame(width: 48, height: 48)
                    Text(self.authStateObserver.appUser?.displayName ?? "")
                }
                .padding()
                
                Form {
                    Section(header: Text("参加中のチーム")) {
                        ForEach(self.presenter.teams.sorted(by: { $0.createdAt!.dateValue() > $1.createdAt!.dateValue() }), id: \.self) { team in
                            if let userId = self.authStateObserver.appUser?.id {
                                self.presenter.linkBuilder(userId: userId, team: team) {
                                    HStack {
                                        Circle()
                                            .frame(width: 24, height: 24)
                                        Text(team.name)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    
                    Section {
                        Button(action: self.presenter.toggleShowNewTeamSheet, label: {
                            HStack {
                                Spacer()
                                Text("チームを作成する")
                                Spacer()
                            }
                        })
                            .disabled(self.authStateObserver.appUser?.teams.count ?? 0 >= 10)
                        
                        Button(action: self.presenter.toggleShowTeamQrScannerSheet, label: {
                            HStack {
                                Spacer()
                                Text("チームに参加する")
                                Spacer()
                            }
                        })
                            .alert(isPresented: self.$presenter.teamJoinAlertPresented) {
                                Alert(title: Text("チーム名"),
                                      message: Text("チームに参加しますか？"),
                                      primaryButton: .default(Text("参加する")) {
                                    self.presenter.teamJoinComfirm(user: self.authStateObserver.appUser!)
                                },
                                      secondaryButton: .cancel() {
                                    self.presenter.teamJoinCancel()
                                })
                            }
                    }
                }
                
                Button(action: self.authStateObserver.signOut) {
                    Text("ログアウト")
                }
            }
            .sheet(isPresented: self.$presenter.newTeamViewPresented) {
                NavigationView {
                    self.presenter.makeAboutNewTeamView(userId: self.authStateObserver.appUser!.id)
                }
            }
            .fullScreenCover(isPresented: self.$presenter.teamQrCodeScannerViewPresented) {
                NavigationView {
                    self.presenter.makeAboutTeamQrCodeScannerView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("アカウント")
        }
        .popup(isPresented: self.$presenter.teamQrCodeScanBannerPresented,
               type: .floater(),
               position: .top,
               animation: .spring(),
               autohideIn: 2) {
            QrCodeScannerBanner()
        }
        .onAppear {
            self.presenter.loadTeams(userId: self.authStateObserver.appUser!.id)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let presenter = HomePresenter(interactor: interactor, router: router)
        
        HomeView(presenter: presenter)
            .environmentObject(AuthStateObserver(user: User(displayName: "アカウント名", teams: [])))
    }
}
