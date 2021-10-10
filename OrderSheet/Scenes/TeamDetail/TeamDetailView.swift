//
//  TeamDetailView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import SwiftUI

struct TeamDetailView: View {
    @ObservedObject var presenter: TeamDetailPresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            VStack {
                Circle()
                    .frame(width: 48, height: 48)
                TextField(self.presenter.team?.name ?? "",
                          text: self.$presenter.inputName,
                          onEditingChanged: self.presenter.onNameEditingChanged,
                          onCommit: self.presenter.onNameCommit )
            }
            .padding()
            
            ZStack {
                Text("")
                    .alert(isPresented: self.$presenter.deleteTeamConfirmAlertPresented) {
                        Alert(title: Text("チームとメッセージの削除"),
                              message: Text("メンバーが存在しないため、チームおよびすべてのメッセージが削除されます。"),
                              primaryButton: .default(Text("削除する")) {
                            
                            self.presenter.leaveAndDeleteTeam(user: self.authStateObserver.appUser!) {
                                self.presentation.wrappedValue.dismiss()
                            }
                        },
                              secondaryButton: .cancel()
                        )
                    }
                
                Form {
                    Section(header: Text("メンバー")) {
                        ForEach(self.presenter.members, id: \.self) { member in
                            HStack {
                                Circle()
                                    .frame(width: 24, height: 24)
                                Text(member.displayName)
                                Spacer()
                            }
                        }
                    }
                    
                    Section {
                        Button(action: self.presenter.showTeamQRCodeView, label: {
                            HStack {
                                Spacer()
                                Text("招待QRコード表示")
                                Spacer()
                            }
                        })
                        
                        Button(action: self.presenter.showLeaveTeamConfirmAlert, label: {
                            HStack {
                                Spacer()
                                Text("チームから抜ける")
                                    .foregroundColor(Color.red)
                                Spacer()
                            }
                        })
                            .alert(isPresented: self.$presenter.leaveTeamConfirmAlertPresented) {
                                Alert(title: Text(self.presenter.team?.name ?? ""),
                                      message: Text("チームから抜けますか？"),
                                      primaryButton: .default(Text("抜ける")) {
                                    
                                    self.presenter.leaveTeam(user: self.authStateObserver.appUser!) {
                                        self.presentation.wrappedValue.dismiss()
                                    }
                                },
                                      secondaryButton: .cancel()
                                )
                            }
                    }
                    
                }
            }
        }
        .sheet(isPresented: self.$presenter.sheetPresented) {
            NavigationView {
                self.presenter.makeAboutTeamQRCodeView()
            }
        }
        .onAppear {
            self.presenter.load()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("チーム")
    }
}

struct TeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let router = TeamDetailRouter()
        let interactor = TeamDetailInteractor()
        let presenter = TeamDetailPresenter(interactor: interactor, router: router, team: Team(name: "チーム名", members: [], owner: ""), members: [User(displayName: "メンバー1", teams: []), User(displayName: "メンバー2", teams: [])])
        
        NavigationView {
            TeamDetailView(presenter: presenter)
        }
    }
}
