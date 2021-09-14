//
//  LoginPresenter.swift
//  OrderSheet
//
//  Created by yum on 2021/09/11.
//

import Foundation
import SwiftUI
import Firebase

class LoginPresenter: ObservableObject {
    
    init() { }
    
    func firebaseSignIn(credential: AuthCredential) {
        FirebaseAuth.signIn(credential: credential)
    }
    
}
