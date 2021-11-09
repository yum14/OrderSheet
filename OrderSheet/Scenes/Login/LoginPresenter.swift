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
    enum Mode {
        case signIn
        case createNewAccount
        case nothing
    }
    
    @Published var sheetPresented = false
    @Published var mode: LoginPresenter.Mode = .nothing
    @Published var showCreateAccountDummyView = false
    @Published var showNoAccountDummyView = false
    
    init() {}
    
    func initialize() {
        self.mode = .nothing
        self.showNoAccountDummyView = false
        self.showCreateAccountDummyView = false
    }

    func showAcountCreationSheet() {
        self.sheetPresented = true
    }
    
    func hideAccountCreationSheet() {
        self.sheetPresented = false
    }

    func onFirebaseSignIn() {
        self.mode = .createNewAccount
        self.showNoAccountDummyView = true
    }
    
    func onFirebaseSignInWithCreateAccount() {
        self.mode = .createNewAccount
        self.showCreateAccountDummyView = true
    }
    
    func onCreateAccountCancel() {
        self.initialize()
    }
    
    func onCreateAccountAccept() {
        self.initialize()
    }
    
}
