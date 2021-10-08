//
//  NewTeamView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/21.
//

import SwiftUI

struct NewTeamView: View {
    @ObservedObject var presenter: NewTeamPresenter
    
    var body: some View {
        Form {
            Section {
                CustomTextField("チーム名", text: self.$presenter.text, isFirstResponder: true, onCommit: { })
            }
            
            Section {
                Button(action: self.presenter.inputCommit) {
                    HStack {
                        Spacer()
                        Text("作成する")
                        Spacer()
                    }
                }
                
                Button(action: self.presenter.inputCancel) {
                    HStack {
                        Spacer()
                        Text("キャンセル")
                        Spacer()
                    }
                }
            }
        }
        .navigationTitle("新しいチーム")
    }
}

struct NewTeamView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = NewTeamInteractor()
        let presenter = NewTeamPresenter(interactor: interactor, user: User(displayName: "test", teams: []))
        NavigationView {
            NewTeamView(presenter: presenter)
        }
    }
}
