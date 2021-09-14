//
//  FirebaseAuth.swift
//  OrderSheet
//
//  Created by yum on 2021/09/14.
//

import Foundation
import Firebase

class FirebaseAuth {
    
    static func signIn(credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { authResult, error in
            if let error = error {
                print("signIn error. \(error.localizedDescription)")
            }
        }
    }
    
    static func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let error as NSError {
            print("signout error. \(error.localizedDescription)")
        }
        
    }
}
