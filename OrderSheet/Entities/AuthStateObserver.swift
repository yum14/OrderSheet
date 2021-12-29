//
//  AuthStateObserver.swift
//  OrderSheet
//
//  Created by yum on 2021/09/28.
//

import Foundation
import SwiftUI
import Firebase

final class AuthStateObserver: UIResponder, ObservableObject {
    enum SignInStatus {
        case success
        case failed
    }
    
    init(user: User) {
        self.appUser = user
    }
    
    @Published var appUser: User?
    private var token: String?
    private var firebaseLoginUser: Firebase.User?
    var notificationToken: String?
    
    var isSignedIn: Bool? {
        if self.signInStatus == .failed {
            return false
        }
        
        if notificationToken == nil {
            return false
        }

        if self.signInStatus == .success && self.firebaseLoginUser != nil && self.appUser != nil {
            return true
        }
        
        return nil
    }
    
    private var firebaseAuthStateObserver: FirebaseAuthStateObserver?
    private var signInStatus: SignInStatus? = nil
    private var userStore: UserStore?
    
    override init() {}
    
    func addListener() {
        self.userStore = UserStore()
        
        self.firebaseAuthStateObserver = FirebaseAuthStateObserver(
            onStateChanged: {(auth: Auth, user: Firebase.User?) in
                guard let user = user else {
                    self.firebaseLoginUser = nil
                    return
                }
                self.firebaseLoginUser = user
                
                
                self.userStore!.setListener(id: user.uid) { user in
                    if let user = user {
                        
                        if let notificationToken = self.notificationToken, user.notificationToken != self.notificationToken {
                            // プッシュ通知トークンを更新する（それにより再度ユーザ情報の読み込みがされる）
                            self.userStore!.updateNotificationToken(id: user.id, notificationToken: notificationToken) { error in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        } else {
                            self.appUser = user
                            self.signInStatus = .success
                        }
                    } else {
                        self.appUser = nil
                        self.signInStatus = .failed
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
        guard let user = self.firebaseLoginUser, let userStore = self.userStore else {
            return
        }
        
        let newUser = User(id: user.uid,
                           displayName: user.displayName ?? "",
                           email: user.email,
                           photoUrl: user.photoURL?.absoluteString,
                           avatarImage: nil,
                           teams: [],
                           notificationToken: self.notificationToken,
                           lastLogin: Date())
        
        userStore.set(newUser) { result in
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
