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
                            .onChange(of: self.presenter.avatarImage) { newValue in
                                
                                if let newImage = newValue {
                                    self.presenter.onAvatarImageChanged(user: self.authStateObserver.appUser!, image: newImage)
                                }
                            }
                        
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
                                            AvatarImage(image: team.avatarImage != nil ? UIImage(data: team.avatarImage!) : nil, defaultImageName: "person.2.circle.fill", length: 28)
                                            Text(team.name)
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        
                        Section {
                            Button {
                                self.presenter.onCreateTeamButtonTapped()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("チームを作成する")
                                    Spacer()
                                }
                            }
                            .disabled(self.authStateObserver.appUser?.teams.count ?? 0 >= 10)

                            Button {
                                self.presenter.onJoinTeamButtonTapped()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("チームに参加する")
                                    Spacer()
                                }
                            }
                            .alert(self.presenter.joinTeam?.name ?? "チームに参加する", isPresented: self.$presenter.showingJoinTeamCancelAlert) {
                                Button("OK") {}
                            } message: {
                                Text("すでに参加中のチームです。")
                            }
                            .alert(self.presenter.joinTeam?.name ?? "チームに参加する", isPresented:
                                    self.$presenter.showingJoinTeamAlert) {
                                Button("参加する", role: .none) {
                                    self.presenter.onJoinTeamAgreementButtonTapped(user: self.authStateObserver.appUser!)
                                }
                                Button("キャンセル", role: .cancel) {
                                    self.presenter.onJoinTeamCancelButtonTapped()
                                }
                            } message: {
                                Text("チームに参加しますか？")
                            }
                        }
                    }
                    .fullScreenCover(isPresented: self.$presenter.showingNewTeamView) {
                        self.presenter.makeAboutNewTeamView(userId: self.authStateObserver.appUser!.id)
                    }
                    
                    Button {
                        self.authStateObserver.signOut()
                    } label: {
                        Text("ログアウト")
                    }
                }
                .fullScreenCover(isPresented: self.$presenter.showingTeamQrCodeScannerView) {
                    NavigationView {
                        self.presenter.makeAboutTeamQrCodeScannerView(user: self.authStateObserver.appUser!)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("ホーム")
                
                ActivityIndicator(isVisible: self.$presenter.showingIndicator)
            }
            .onAppear {
                self.presenter.initialLoad(user: self.authStateObserver.appUser!)
            }
            .popup(isPresented: self.$presenter.showingTeamQrCodeScanBanner,
                   type: .floater(),
                   position: .top,
                   animation: .spring(),
                   autohideIn: 5) {
                QrCodeScannerBanner()
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
