//
//  FirebaseAuthStateObserver.swift
//  OrderSheet
//
//  Created by yum on 2021/09/14.
//

import Foundation
import Firebase

class FirebaseAuthStateObserver: ObservableObject {
    private var listener: AuthStateDidChangeListenerHandle!

    init(onStateChanged: @escaping (Firebase.Auth, Firebase.User?) -> Void = { _, _ in },
         onIdTokenForcingRefresh: @escaping (String?, Error?) -> Void = { _, _ in }) {
        
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
            onStateChanged(auth, user)
            user?.getIDTokenForcingRefresh(true, completion: onIdTokenForcingRefresh)
        }
    }

    func signIn(credential: AuthCredential, completion: ((AuthDataResult?, Error?) -> Void)?) {
        Auth.auth().signIn(with: credential, completion: completion)
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("signout error. \(error.localizedDescription)")
        }
    }
    
    deinit {
        Auth.auth().removeStateDidChangeListener(listener)
    }

}
