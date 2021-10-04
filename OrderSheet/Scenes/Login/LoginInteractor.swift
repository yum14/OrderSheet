//
//  LoginInteractor.swift
//  OrderSheet
//
//  Created by yum on 2021/09/27.
//

import Foundation
import Firebase

protocol LoginUsecase {
    func signedIn(credential: AuthCredential)
    func createAcount(credential: AuthCredential, completion: @escaping (Result<(), Error>) -> Void)
}

final class LoginInteractor {
    let store: UserStore
    
    init(store: UserStore) {
        self.store = store
    }
}

extension LoginInteractor: LoginUsecase {
    func signedIn(credential: AuthCredential) {
        
    }

    func createAcount(credential: AuthCredential, completion: @escaping (Result<(), Error>) -> Void = { _ in }) {
//        self.store.set(User(displayName: credential.,
//                            email: <#T##String?#>,
//                            photoUrl: <#T##String?#>,
//                            avatarImage: <#T##Data?#>,
//                            teams: <#T##[String]#>,
//                            lastLogin: <#T##Date#>),
//                       completion: <#T##(Result<(), Error>) -> Void#>)
        
    }
}
