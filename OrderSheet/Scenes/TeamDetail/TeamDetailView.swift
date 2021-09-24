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
                Text(self.presenter.team.name)
            }
            .padding()
            
            Form {
                Section(header: Text("メンバー")) {
                    ForEach(self.presenter.members, id: \.self) { member in
                        HStack {
                            Circle()
                                .frame(width: 24, height: 24)
                            Text(member.name)
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("チーム")
    }
}

struct TeamDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = TeamDetailPresenter(team: Team(name: "チーム名", members: []), members: [User(name: "メンバー1", teams: []), User(name: "メンバー2", teams: [])])
        
        NavigationView {
            TeamDetailView(presenter: presenter)
        }
    }
}
