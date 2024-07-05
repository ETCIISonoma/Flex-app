//
//  PairedView.swift
//  Flex
//
//  Created by Collin Cameron on 7/4/24.
//

import Foundation
import SwiftUI

struct PairedView: View {
    let accessorySessionManager: AccessorySessionManager
    
    @AppStorage("accessoryPaired") private var accessoryPaired = false
    
    @State var isConnected = false
    
    @State var isRelayOn = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Paired, \(isConnected ? "connected" : "not connected")")
                Button {
                    isConnected = accessorySessionManager.peripheralConnected
                } label: {
                    Text("Refresh whether connected")
                }
                Text("Distance:")
                Text(accessorySessionManager.ultrasonicDistance ?? "nil")
                
                Button {
                    accessorySessionManager.connect()
                } label: {
                    Text("Connect")
                }.buttonStyle(.borderedProminent)
                
                Toggle("Relay is on", isOn: $isRelayOn)
                    .onChange(of: isRelayOn) {
                        accessorySessionManager.setRelayState(isOn: isRelayOn)
                    }
                
                Spacer()
                
                NavigationLink {
                    OrientationExplainationView()
                } label: {
                    Text("Show orientations")
                }
                
                Spacer()
                Button {
                    accessorySessionManager.removeAccessory()
                    withAnimation {
                        accessoryPaired = false
                    }
                } label: {
                    Text("Reset app")
                }.buttonStyle(.bordered)
                .controlSize(.large)
            }.padding()
                .onAppear {
                    Task {
                        while !accessorySessionManager.peripheralConnected {
                            accessorySessionManager.connect()
                            try await Task.sleep(nanoseconds: 200000000)
                        }
                        
                        isConnected = accessorySessionManager.peripheralConnected
                    }
                }
        }
    }
}

#Preview {
    PairedView(accessorySessionManager: AccessorySessionManager())
}
