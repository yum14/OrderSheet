//
//  FirebaseAuthStateObserver.swift
//  OrderSheet
//
//  Created by yum on 2021/09/14.
//

import Foundation
import Firebase



// TODO: AuthStateObserverでラップするイメージにする


class FirebaseAuthStateObserver: ObservableObject {
//    var isSignedIn: Bool {
//        return self.uid != nil
//    }
//    @Published var token: String?
//    @Published var uid: String?
//    @Published var displayName: String?
//    @Published var email: String?
//    @Published var photoURL: URL?
    
    private var listener: AuthStateDidChangeListenerHandle!
//    private let store = UserStore()

    init(onStateChanged: @escaping (Firebase.Auth, Firebase.User?) -> Void = { _, _ in },
         onIdTokenForcingRefresh: @escaping (String?, Error?) -> Void = { _, _ in }) {
        
        listener = Auth.auth().addStateDidChangeListener { (auth, user) in
//            guard let user = user else {
//                print("sign out")
//
//                self.token = nil
//                self.uid = nil
//                self.displayName = nil
//                self.email = nil
//                self.photoURL = nil
                
//                onStateChanged(auth, nil)
//
//                return
//            }
            
            onStateChanged(auth, user)
            user?.getIDTokenForcingRefresh(true, completion: onIdTokenForcingRefresh)
            
            
//            self.uid = user.uid
//            self.displayName = user.displayName
//            self.email = user.email
//            self.photoURL = user.photoURL
            

//            user?.getIDTokenForcingRefresh(true) {(token: String?, error: Error?) in
//                if let error = error {
//                    print("can't get token. \(error)")
//                    return
//                }
//                self.token = token
//            }
//            print("sign in")
            
            
            // TODO: 移動する
            
//            let newUser = User(id: user.uid, displayName: user.displayName ?? "", email: user.email, photoUrl: user.photoURL?.absoluteString, avatarImage: nil, teams: [], lastLogin: Date())
//            self.store.set(newUser, completion: { result in
//                switch result {
//                case .success():
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            })
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
