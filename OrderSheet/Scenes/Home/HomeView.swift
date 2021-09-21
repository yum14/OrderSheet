//
//  HomeView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/20.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var presenter: HomePresenter
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Circle()
                        .frame(width: 48, height: 48)
                    Text(self.presenter.user.name)
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
                        Button(action: {}, label: {
                            HStack {
                                Spacer()
                                Text("チームを作成する")
                                Spacer()
                            }
                        })
                        
                        Button(action: {}, label: {
                            HStack {
                                Spacer()
                                Text("チームに参加する")
                                Spacer()
                            }
                        })
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("アカウント")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = HomePresenter(user: User(name: "アカウント名", teams: []), teams: [Team(name: "チーム1", members: []), Team(name: "チーム2", members: [])])
        
        HomeView(presenter: presenter)
    }
}
