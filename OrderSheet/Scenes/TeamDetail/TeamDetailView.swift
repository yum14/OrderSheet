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
        ZStack {
            VStack {
                VStack {
                    AvatarImagePicker(selectedImage: self.$presenter.avatarImage,
                                      defaultImageName: "person.2.circle.fill")
                        .onChange(of: self.presenter.avatarImage) { newValue in
                            
                            if let newImage = newValue {
                                self.presenter.onAvatarImageChanged(image: newImage)
                            }
                        }
                    
                    TextField("チーム名",
                              text: self.$presenter.inputName,
                              onEditingChanged: self.presenter.onNameEditingChanged,
                              onCommit: self.presenter.onNameCommit )
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                ZStack {
                    Text("")
                        .alert(isPresented: self.$presenter.showingDeleteTeamConfirm) {
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
                                    AvatarImage(image: self.authStateObserver.appUser?.avatarImage != nil ? UIImage(data: self.authStateObserver.appUser!.avatarImage!) : nil, defaultImageName: "person.crop.circle.fill", length: 28)
                                    Text(member.displayName)
                                    Spacer()
                                }
                            }
                        }
                        
                        Section {
                            Button {
                                self.presenter.showTeamQRCodeView()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("招待QRコード表示")
                                    Spacer()
                                }
                            }
                            
                            Button {
                                self.presenter.showLeaveTeamConfirmAlert()
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("チームから抜ける")
                                        .foregroundColor(Color.red)
                                    Spacer()
                                }
                            }
                            
                            .alert(self.presenter.team.name, isPresented: self.$presenter.showingLeaveTeamConfirm) {
                                Button("抜ける", role: .destructive) {
                                    self.presenter.leaveTeam(user: self.authStateObserver.appUser!) {
                                        self.presentation.wrappedValue.dismiss()
                                    }
                                }
                                Button("キャンセル", role: .cancel) {}
                            } message: {
                                Text("チームから抜けますか？")
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
            
            ActivityIndicator(isVisible: self.$presenter.showingIndicator)
        }
        .onAppear {
            self.presenter.load()
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("チーム詳細")
    }
}

struct TeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let router = TeamDetailRouter()
        let interactor = TeamDetailInteractor()
        let presenter = TeamDetailPresenter(interactor: interactor, router: router, team: Team(name: "チーム名", members: [], owner: ""), members: [User(displayName: "メンバー1", teams: []), User(displayName: "メンバー2", teams: [])])
        let authStateObserver = AuthStateObserver()
        
        NavigationView {
            TeamDetailView(presenter: presenter)
                .environmentObject(authStateObserver)
        }
    }
}
