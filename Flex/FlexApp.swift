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
    let selectedSets = numSets(selectedSets: 3)
    let wf = workoutFlag(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false)
    
    var body: some Scene {
        WindowGroup {
            BLEPairingView()
                .environmentObject(counter)
                .environmentObject(targetAreas)
                .environmentObject(selectedSets)
                .environmentObject(wf)
        }
    }
}

private class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        InterfaceOrientationCoordinator.shared.supportedOrientations
    }
}
