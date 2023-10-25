//
//  ChatAppApp.swift
//  ChatApp
//
//  Created by admin on 25/10/2023.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct ChatAppApp: App {
    
     @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
     @StateObject private var appState = AppState()
     @StateObject private var model = Model()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $appState.routes) {
                
                ZStack{
                    if Auth.auth().currentUser != nil {
                       // MainView()
                        SignUpView()
                    }else{
                        Login()
                    }
                }.navigationDestination(for: Route.self) { route in
                    switch route {
                    case .mainScreen:
                        MainView()
                    case .login:
                        Login()
                    case .signUp:
                        SignUpView()
                    }
                }
            }
            .environmentObject(appState)
            .environmentObject(model)
        }
    }
}
