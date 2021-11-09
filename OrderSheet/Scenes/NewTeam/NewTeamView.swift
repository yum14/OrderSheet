//
//  NewTeamView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/21.
//

import SwiftUI

struct NewTeamView: View {
    @ObservedObject var presenter: NewTeamPresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("チーム名")) {
                    CustomTextField("新しいチーム", text: self.$presenter.text, isFirstResponder: true, onCommit: { })
                }
                
                Section {
                    Button(action: { self.presenter.inputCommit(user: self.authStateObserver.appUser!) }) {
                        HStack {
                            Spacer()
                            Text("作成する")
                            Spacer()
                        }
                    }
                    .disabled(self.presenter.text.isEmpty)
                    
                    Button(action: self.presenter.inputCancel) {
                        HStack {
                            Spacer()
                            Text("キャンセル")
                            Spacer()
                        }
                    }
                }
            }
            .actionSheet(isPresented: self.$presenter.showingDismissConfirm) {
                ActionSheet(title: Text(""),
                            message: Text("編集内容を破棄しますか？"),
                            buttons: [
                                .destructive(Text("破棄する")) {
                                    self.dismiss()
                                },
                                .cancel()
                            ])
            }
            .navigationTitle("新しいチーム")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if self.presenter.editing {
                            self.presenter.showDismissConfirm()
                        } else {
                            self.dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct NewTeamView_Previews: PreviewProvider {
    static var previews: some View {
        let interactor = NewTeamInteractor()
        let presenter = NewTeamPresenter(interactor: interactor, onCommit: {_ in }, onCanceled: {})
        NavigationView {
            NewTeamView(presenter: presenter)
                .environmentObject(AuthStateObserver(user: User(displayName: "アカウント名", teams: [])))
        }
    }
}
