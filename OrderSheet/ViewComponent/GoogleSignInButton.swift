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
        
        Button {
            guard let clientID = FirebaseApp.app()?.options.clientID else {
                return
            }
            
            let config = GIDConfiguration(clientID: clientID)
            
            GIDSignIn.sharedInstance.signIn(with: config, presenting: self.getRootViewController()) { user, error in
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
        } label: {
            HStack(spacing: 8) {
                Image("GoogleIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                Text("Googleでログイン")
                    .foregroundColor(.primary)
                    .fontWeight(.medium)
            }
            .padding(.vertical, 7)
            .frame(width: 280)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .strokeBorder(Color.primary, lineWidth: 0.7)
            )
        }
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .init()
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
}

struct GoogleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        GoogleSignInButton(signedIn: { _ in })
    }
}


//struct GoogleSignInButton: View {
//    var signedIn: (AuthCredential) -> Void
//    var onTapped: () -> Void = {}
//
//    var body: some View {
//        VStack {
//            GoogleSignInRepresent(signedIn: self.signedIn, onTapped: self.onTapped)
//                .frame(width: 306, height: 46)
//                .font(.title)
////                .background(Color.red)
//        }
//    }
//}

//struct GoogleSignInRepresent: UIViewRepresentable {
//    let signedIn: (AuthCredential) -> Void
//    let onTapped: () -> Void
//
//    private let config: GIDConfiguration?
//
//    init(signedIn: @escaping (AuthCredential) -> Void = { _ in }, onTapped: @escaping () -> Void = {}) {
//        self.signedIn = signedIn
//        self.onTapped = onTapped
//
//        if let clientID = FirebaseApp.app()?.options.clientID {
//            config = GIDConfiguration(clientID: clientID)
//        } else {
//            config = nil
//        }
//    }
//
//    func makeUIView(context: Context) -> GIDSignInButton {
//        let button = GIDSignInButton()
//        button.style = .wide
//        button.colorScheme = GIDSignInButtonColorScheme.light
//        button.addAction(.init(handler: { _ in
//
//            guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else { return }
//            guard let config = self.config else { return }
//
//            self.onTapped()
//
//            GIDSignIn.sharedInstance.signIn(with: config, presenting: presentingViewController) { user, error in
//                if let error = error {
//                    print(error.localizedDescription)
//                    return
//                }
//                guard let authentication = user?.authentication, let idToken = authentication.idToken else {
//                    print("authentication error.")
//                    return
//                }
//
//                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
//
//                self.signedIn(credential)
//            }
//        }), for: .touchUpInside)
//
//        return button
//    }
//
//    func updateUIView(_ uiView: GIDSignInButton, context: Context) { }
//}
