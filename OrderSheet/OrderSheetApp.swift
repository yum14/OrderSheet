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
    
    var authStateObserver: AuthStateObserver
    
    init() {
        FirebaseApp.configure()
        self.authStateObserver = AuthStateObserver()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.authStateObserver)
        }
    }
    
    class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            if #available(iOS 10.0, *) {
              // For iOS 10 display notification (sent via APNS)
              UNUserNotificationCenter.current().delegate = self

              let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
              UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: { _, _ in }
              )
            } else {
              let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
              application.registerUserNotificationSettings(settings)
            }

            application.registerForRemoteNotifications()
            return true
        }
        
        func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
            return GIDSignIn.sharedInstance.handle(url)
        }
        
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
          print("Firebase token: \(String(describing: fcmToken))")
        }
    }
}
