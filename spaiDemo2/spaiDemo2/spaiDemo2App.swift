//
//  spaiDemo2App.swift
//  spaiDemo2
//
//  Created by Junyeong Jo on 1/1/24.
//

import SwiftUI
import Firebase

@main
struct spaiDemo2App: App {
    
    var navigationStateManager = NavigationStateManager()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            starterView()
                .environmentObject(navigationStateManager)
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}

// initialize firebase
class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    print("Configured Firebase!!!")
    return true
  }
}
