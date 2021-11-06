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
            ZStack {
                VStack {
                    VStack {
                        AvatarImagePicker(selectedImage: self.$presenter.avatarImage,
                                          defaultImageName: "person.crop.circle.fill")
                        
                        TextField("アカウント名",
                                  text: self.$presenter.inputName,
                                  onEditingChanged: self.presenter.onNameEditingChanged,
                                  onCommit: { self.presenter.onNameCommit(user: self.authStateObserver.appUser!) } )
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    Form {
                        Section(header: Text("参加中のチーム")) {
                            ForEach(self.presenter.teams.sorted(by: { $0.createdAt.dateValue() > $1.createdAt.dateValue() }), id: \.self) { team in
                                if let userId = self.authStateObserver.appUser?.id {
                                    self.presenter.linkBuilder(userId: userId, team: team) {
                                        HStack {
                                            AvatarImage(image: self.presenter.teamAvatarImage, defaultImageName: "person.2.circle.fill", width: 28, height: 28)
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
                    .fullScreenCover(isPresented: self.$presenter.showingNewTeam) {
                        self.presenter.makeAboutNewTeamView(userId: self.authStateObserver.appUser!.id)
                    }
                    
                    Button(action: self.authStateObserver.signOut) {
                        Text("ログアウト")
                    }
                }
                .fullScreenCover(isPresented: self.$presenter.teamQrCodeScannerViewPresented) {
                    NavigationView {
                        self.presenter.makeAboutTeamQrCodeScannerView()
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("ホーム")
                
                ActivityIndicator(isVisible: self.$presenter.showingIndicator)
            }
            .popup(isPresented: self.$presenter.teamQrCodeScanBannerPresented,
                   type: .floater(),
                   position: .top,
                   animation: .spring(),
                   autohideIn: 2) {
                QrCodeScannerBanner()
            }
                   .onAppear {
                       self.presenter.initialLoad(user: self.authStateObserver.appUser!)
                   }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = HomeInteractor()
        let router = HomeRouter()
        let teams = [Team(name: "team1", members: [], owner: "owner"),
                     Team(name: "team2", members: [], owner: "owner")]
        let presenter = HomePresenter(interactor: interactor, router: router, teams: teams)
        
        HomeView(presenter: presenter)
            .environmentObject(AuthStateObserver(user: User(displayName: "アカウント名", teams: [])))
    }
}
