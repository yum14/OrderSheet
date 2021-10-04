//
//  AppleSignInButton.swift
//  OrderSheet
//
//  Created by yum on 2021/09/15.
//

import SwiftUI
import UIKit
import AuthenticationServices
import CryptoKit
import FirebaseAuth

struct AppleSignInButton: View {
    var signedIn: (AuthCredential) -> Void
    var onTapped: () -> Void = {}
    
    var body: some View {
        AppleSignInButtonViewController(signedIn: self.signedIn, onTapped: self.onTapped)
            .frame(width: 130, height: 30)
    }
}

struct AppleSignInButton_Previews: PreviewProvider {
    static var previews: some View {
        AppleSignInButton(signedIn: { _ in })
    }
}

struct AppleSignInButtonViewController: UIViewControllerRepresentable {
    
    var signedIn: (AuthCredential) -> Void
    var onTapped: () -> Void
    
    init(signedIn: @escaping (AuthCredential) -> Void, onTapped: @escaping () -> Void) {
        self.signedIn = signedIn
        self.onTapped = onTapped
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = AppleSignInViewController()
        viewController.signedIn = self.signedIn
        viewController.onTapped = self.onTapped
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}


class AppleSignInViewController: UIViewController {

    var signedIn: ((AuthCredential) -> Void)?
    var onTapped: (() -> Void)?
    fileprivate var currentNonce: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appleSignInButton = ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
        appleSignInButton.addTarget(self, action: #selector(appleSignInButtonTapped(sender:)), for: .touchUpInside)
        self.view.addSubview(appleSignInButton)
    }
    
    @objc func appleSignInButtonTapped(sender: Any) {
        self.onTapped?()
        startSignInWithAppleFlow()
    }
    
    @available(iOS 13, *)
    private func startSignInWithAppleFlow() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
        return String(format: "%02x", $0)
        }.joined()

        return hashString
    }
}

extension AppleSignInViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = UIApplication.shared.delegate?.window else {
            fatalError()
        }
        return window!
    }
}

extension AppleSignInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idTokenString,
                rawNonce: nonce
            )
            
            self.signedIn?(credential)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error.localizedDescription)
    }
}
