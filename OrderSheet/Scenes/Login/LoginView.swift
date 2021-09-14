//
//  LoginView.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var presenter: LoginPresenter
    
    var body: some View {
        VStack {
            GoogleSignInButton(signedIn: self.presenter.firebaseSignIn)
                .padding(.horizontal, 40)
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        let presenter = LoginPresenter()
        LoginView(presenter: presenter)
    }
}
