//
//  ContentView.swift
//  Flex
//

import SwiftUI
import InterfaceOrientation

struct BLEPairingView: View {
    @ObservedObject var accessorySessionManager = AccessorySessionManager.shared
    @AppStorage("accessoryPaired") private var accessoryPaired = true
    
    var body: some View {
        if accessoryPaired {
            
            SignInView(accessorySessionManager: accessorySessionManager)
            //PairedView(accessorySessionManager: accessorySessionManager)
            
            
            
            //PreWorkoutSummaryView(workout: Workout(title: "lala", description: "lalala", iconName: "hehe", category: "ur mom"))
            // this is for testing, should actually proceed to the sign in page.
        } else {
            VStack {
                VStack {
                    Spacer()
                    
                    Text("Welcome to")
                        .font(.title2)
                    Text("Flex")
                        .font(.system(size: 90, weight: .bold))
                        .foregroundStyle(Color.accentColor)
                    Text("Pair your F1 to get started.")
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                }.safeAreaPadding()
                
                ZStack(alignment: .bottom) {
                    Image("InitialPhoto")
                        .resizable()
                        .scaledToFit()
                        
                    Button {
                        accessorySessionManager.presentPicker()
                    } label: {
                        Text("Pair")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .safeAreaPadding(.vertical)
                    .padding(28)
                }
            }.ignoresSafeArea()
            .interfaceOrientations(.portrait)
        }
    }
}

#Preview {
    BLEPairingView()
}
