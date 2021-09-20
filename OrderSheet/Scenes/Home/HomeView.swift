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
        VStack {
            HStack {
                Circle()
                    .frame(width: 48, height: 48)
                Text(self.presenter.user.name)
                Spacer()
            }
            .padding()
            
            List {
                Section(header: Text("参加中のチーム")) {
                    ForEach(self.presenter.user.teams, id: \.self) { team in
                        Text(team.name)
                    }
                }
                
            }
            
            HStack {
                Spacer()
                Button(action: {}, label: {
                    Text("チームを作成")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("Main"))
                        .cornerRadius(24)
                })
                Spacer()
                Button(action: {}, label: {
                    Text("チームに参加")
                        .padding()
                        .foregroundColor(.white)
                        .background(Color("Main"))
                        .cornerRadius(24)
                })
                Spacer()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = HomePresenter(user: User(name: "アカウント名", teams: [Team(name: "チーム1"), Team(name: "チーム2")]))
        HomeView(presenter: presenter)
    }
}
