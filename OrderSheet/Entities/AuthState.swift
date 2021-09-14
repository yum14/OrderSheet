//
//  AuthState.swift
//  OrderSheet
//
//  Created by yum on 2021/09/14.
//

import Foundation
import Firebase

class AuthState: ObservableObject {
    var isSignedIn: Bool {
        return self.uid != nil
    }
    @Published var token: String?
    @Published var uid: String?
    @Published var displayName: String?
    @Published var email: String?
    @Published var photoURL: URL?
    
    private var listener: AuthStateDidChangeListenerHandle!

    init() {
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            guard let user = user else {
                print("sign out")
                
                self.token = nil
                self.uid = nil
                self.displayName = nil
                self.email = nil
                self.photoURL = nil
                return
            }
            
            self.uid = user.uid
            self.displayName = user.displayName
            self.email = user.email
            self.photoURL = user.photoURL
            
            user.getIDTokenForcingRefresh(true) {(token: String?, error: Error?) in
                if let error = error {
                    print("can't get token. \(error)")
                    return
                }   
                self.token = token
            }
            print("sign in")
        }
    }

    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }

}
