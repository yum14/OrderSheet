//
//  LoginView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var presenter: LoginPresenter
    @EnvironmentObject var authStateObserver: AuthStateObserver
    
    @State var noAccountConfirmPresented = false
    @State var createAccountConfirmPresented = false
    
    var body: some View {
        ZStack {
            VStack {
                
                GoogleSignInButton(signedIn: { credential in
                    self.authStateObserver.signIn(credential: credential) { _ in
                        self.presenter.onFirebaseSignIn()
                    }
                })
                    .frame(width: 260)
                
                AppleSignInButton(signedIn: { credential in
                    self.authStateObserver.signIn(credential: credential) { _ in
                        self.presenter.onFirebaseSignIn()
                    }
                })
                
                Divider()
                    .frame(width: 260)
                    .padding(.vertical, 4)
                
                Button(action: self.presenter.showAcountCreationSheet) {
                    Text("アカウントを作成")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(width: 260, height: 32)
                }
                .foregroundColor(.white)
                .background(Color("Main"))
                .cornerRadius(50)
                
            }
            .sheet(isPresented: self.$presenter.sheetPresented) {
                GoogleSignInButton(signedIn: { credential in
                    self.authStateObserver.signIn(credential: credential) { _ in
                        self.presenter.onFirebaseSignInWithCreateAccount()
                    }
                }, onTapped: {
                    self.presenter.hideAccountCreationSheet()
                })
                    .frame(width: 260)
                AppleSignInButton(signedIn: { credential in
                    self.authStateObserver.signIn(credential: credential) { _ in
                        self.presenter.onFirebaseSignInWithCreateAccount()
                    }
                }, onTapped: {
                    self.presenter.hideAccountCreationSheet()
                })
            }
            
            if self.presenter.showNoAccountDummyView && self.authStateObserver.isSignedIn == false {
                Text("")
                    .frame(width: 0, height: 0)
                    .alert(isPresented: self.$noAccountConfirmPresented) {
                        Alert(title: Text("ユーザが存在しない"),
                              message: Text("アカウントを作成しますか？"),
                              primaryButton: .default(Text("作成する"), action: {
                            
                            self.authStateObserver.createAccount() {
                                self.presenter.onCreateAccountAccept()
                            }
                        }),
                              secondaryButton: .cancel({
                            
                            self.authStateObserver.signOut()
                            self.presenter.onCreateAccountCancel()
                        }))
                    }
                    .onAppear {
                        self.noAccountConfirmPresented = true
                    }
            }
            
            if self.presenter.showCreateAccountDummyView && self.authStateObserver.isSignedIn == false {
                Text("")
                    .frame(width: 0, height: 0)
                    .alert(isPresented: self.$createAccountConfirmPresented) {
                        Alert(title: Text("アカウント作成"),
                              message: Text("アカウントを作成しますか？"),
                              primaryButton: .default(Text("作成する"), action: {
                            
                            self.authStateObserver.createAccount() {
                                self.presenter.onCreateAccountAccept()
                            }
                        }),
                              secondaryButton: .cancel({
                            
                            self.authStateObserver.signOut()
                            self.presenter.onCreateAccountCancel()
                        }))
                    }
                    .onAppear {
                        self.createAccountConfirmPresented = true
                    }
            }
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = LoginPresenter()
        LoginView(presenter: presenter)
    }
}
