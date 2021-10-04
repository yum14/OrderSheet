//
//  AuthStateObserver.swift
//  OrderSheet
//
//  Created by yum on 2021/09/28.
//

import Foundation
import Firebase

final class AuthStateObserver: ObservableObject {
    enum SignInStatus {
        case success
        case failed
    }
    
    @Published var appUser: User?
    @Published var token: String?
    @Published var firebaseLoginUser: Firebase.User?
    
    var isSignedIn: Bool? {        
        if self.signInStatus == .failed {
            return false
        }
        
        if self.signInStatus == .success && self.firebaseLoginUser != nil && self.appUser != nil {
            return true
        }

        return nil
    }
    
    private var firebaseAuthStateObserver: FirebaseAuthStateObserver?
    private var signInStatus: SignInStatus? = nil
    private let store = UserStore()
    
    init() {
        
        self.firebaseAuthStateObserver = FirebaseAuthStateObserver(
            onStateChanged: {(auth: Auth, user: Firebase.User?) in
                guard let user = user else {
                    self.firebaseLoginUser = nil
                    return
                }
                self.firebaseLoginUser = user

                self.store.get(id: user.uid) { result in
                    switch result {
                    case .success(let dbUser):
                        if let dbUser = dbUser {
                            self.appUser = dbUser
                            self.signInStatus = .success
                        } else {
                            self.appUser = nil
                            self.signInStatus = .failed
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            },
            onIdTokenForcingRefresh: {(token: String?, error: Error?) in
                if let error = error {
                    print(error.localizedDescription)
                }
                self.token = token
            })
    }
    
    func signIn(credential: AuthCredential, completion: ((AuthCredential) -> Void)? = { _ in }) {
        self.firebaseAuthStateObserver?.signIn(credential: credential) { _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            completion?(credential)
        }
    }
    
    func signOut() {
        self.appUser = nil
        self.signInStatus = nil
        self.firebaseAuthStateObserver?.signOut()
    }
    
    func createAccount(completion: (() -> Void)? = {}) {
        guard let user = self.firebaseLoginUser else {
            return
        }
        
        let newUser = User(id: user.uid,
                           displayName: user.displayName ?? "",
                           email: user.email,
                           photoUrl: user.photoURL?.absoluteString,
                           avatarImage: nil,
                           teams: [],
                           lastLogin: Date())
        
        self.store.set(newUser) { result in
            switch result {
            case .success():
                self.appUser = newUser
                self.signInStatus = .success
                completion?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
