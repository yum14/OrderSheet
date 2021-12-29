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
    @State var showLoadingIndicator = false
    
    var body: some View {
        ZStack {
            Color("Main")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                VStack {
                    GoogleSignInButton(signedIn: { credential in
                        self.showLoadingIndicator = true
                        self.authStateObserver.signIn(credential: credential) { _ in
                            self.showLoadingIndicator = false
                            self.presenter.onFirebaseSignIn()
                        }
                    })
                    
                    AppleSignInButton(signedIn: { credential in
                        self.showLoadingIndicator = true
                        self.authStateObserver.signIn(credential: credential) { _ in
                            self.showLoadingIndicator = false
                            self.presenter.onFirebaseSignIn()
                        }
                    })
                        .padding(.top, 4)
                }
                .padding(.bottom, 40)
            }
            
            if self.presenter.showNoAccountDummyView && self.authStateObserver.isSignedIn == false {
                Text("")
                    .frame(width: 0, height: 0)
                
                    .alert("アカウントが存在しません。",
                           isPresented: self.$noAccountConfirmPresented) {
                        
                        Button("作成する", role: .none) {
                            self.authStateObserver.createAccount() {
                                self.presenter.onCreateAccountAccept()
                            }
                        }
                        Button("キャンセル", role: .cancel) {
                            self.authStateObserver.signOut()
                            self.presenter.onCreateAccountCancel()
                        }
                    } message: {
                        Text("新規作成しますか？")
                    }
                    .onAppear {
                        self.noAccountConfirmPresented = true
                    }
            }

            ActivityIndicator(isVisible: self.$showLoadingIndicator)
        }
        .onAppear {
            self.presenter.initialize()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = LoginPresenter()
        LoginView(presenter: presenter)
    }
}
