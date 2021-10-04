//
//  GoogleSignInButton.swift
//  OrderSheet
//
//  Created by yum on 2021/09/12.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct GoogleSignInButton: View {
    var signedIn: (AuthCredential) -> Void
    var onTapped: () -> Void = {}
    
    var body: some View {
        VStack {
            GoogleSignInRepresent(signedIn: self.signedIn, onTapped: self.onTapped)
                .frame(height: 48)
        }
    }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton(signedIn: { _ in })
    }
}

struct GoogleSignInRepresent: UIViewRepresentable {
    let signedIn: (AuthCredential) -> Void
    let onTapped: () -> Void
    
    private let config: GIDConfiguration?
    
    init(signedIn: @escaping (AuthCredential) -> Void = { _ in }, onTapped: @escaping () -> Void = {}) {
        self.signedIn = signedIn
        self.onTapped = onTapped

        if let clientID = FirebaseApp.app()?.options.clientID {
            config = GIDConfiguration(clientID: clientID)
        } else {
            config = nil
        }
    }
    
    func makeUIView(context: Context) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.addAction(.init(handler: { _ in
            
            guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
            guard let config = self.config else { return }
            
            self.onTapped()
            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingViewController) { user, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                guard let authentication = user?.authentication, let idToken = authentication.idToken else {
                    print("authentication error.")
                    return
                }
                
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)

                self.signedIn(credential)
            }
        }), for: .touchUpInside)
        
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: Context) { }
}
