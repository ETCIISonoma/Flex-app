//
//  FlexApp.swift
//  Flex
//

import SwiftUI
import InterfaceOrientation

@main
struct FlexApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    let counter = Counter(counter: 0)
    let targetAreas = TargetAreaStore(targetAreas: ["High", "Low", "Chest"]) // change later.
    
    var body: some Scene {
        WindowGroup {
            BLEPairingView()
                .environmentObject(counter)
                .environmentObject(targetAreas)
        }
    }
}

private class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        InterfaceOrientationCoordinator.shared.supportedOrientations
    }
}
