//
//  HomeView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Circle()
                        .frame(width: 48, height: 48)
                    Text(self.authStateObserver.appUser!.displayName)
                }
                .padding()
                
                Form {
                    Section(header: Text("参加中のチーム")) {
                        ForEach(self.presenter.teams, id: \.self) { team in
                            self.presenter.linkBuilder(team: team) {
                                HStack {
                                    Circle()
                                        .frame(width: 24, height: 24)
                                    Text(team.name)
                                    Spacer()
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
                                      primaryButton: .default(Text("参加する"), action: {}),
                                      secondaryButton: .cancel({}))
                            }
                    }
                }
            }
            .sheet(isPresented: self.$presenter.newTeamViewPresented) {
                NavigationView {
                    self.presenter.makeAboutNewTeamView()
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = HomePresenter(user: User(displayName: "アカウント名", teams: []), teams: [Team(name: "チーム1", members: []), Team(name: "チーム2", members: [])])
        
        HomeView(presenter: presenter)
    }
}
