//
//  TeamDetailView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import SwiftUI

struct TeamDetailView: View {
    @ObservedObject var presenter: TeamDetailPresenter
    
    var body: some View {
        VStack {
            VStack {
                Circle()
                    .frame(width: 48, height: 48)
                TextField("チーム名",
                          text: self.$presenter.inputName,
                          onEditingChanged: self.presenter.onNameEditingChanged,
                          onCommit: self.presenter.onNameCommit )
            }
            .padding()
            
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
                    
                    Button(action: {}, label: {
                        HStack {
                            Spacer()
                            Text("チームから抜ける")
                                .foregroundColor(Color.red)
                            Spacer()
                        }
                    })
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
        let presenter = TeamDetailPresenter(interactor: interactor, router: router, team: Team(name: "チーム名", members: []), members: [User(displayName: "メンバー1", teams: []), User(displayName: "メンバー2", teams: [])])
        
        NavigationView {
            TeamDetailView(presenter: presenter)
        }
    }
}
