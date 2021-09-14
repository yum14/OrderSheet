//
//  OrderSheetApp.swift
//  OrderSheet
//
//  Created by yum on 2021/09/07.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct OrderSheetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var authState: AuthState
    
    init() {
        FirebaseApp.configure()
        self.authState = AuthState()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.authState)
        }
    }
    
    class AppDelegate: UIResponder, UIApplicationDelegate {
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            return true
        }
        
        func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        }
    }
}
