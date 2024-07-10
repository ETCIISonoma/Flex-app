//
//  ContentView.swift
//  Flex
//

import SwiftUI
import InterfaceOrientation

struct ContentView: View {
    @State var accessorySessionManager = AccessorySessionManager()
    @AppStorage("accessoryPaired") private var accessoryPaired = false
    
    var body: some View {
        if accessoryPaired {
            PairedView(accessorySessionManager: accessorySessionManager)
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
    ContentView()
}
