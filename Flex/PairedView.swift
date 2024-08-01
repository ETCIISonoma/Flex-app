//
//  PairedView.swift
//  Flex
//

import Foundation
import SwiftUI

struct PairedView: View {
    @ObservedObject var accessorySessionManager = AccessorySessionManager.shared
    
    @AppStorage("accessoryPaired") private var accessoryPaired = false
    
    @State var isConnected = false
    @State var newState: UInt = 0
    @State var newTorque: UInt = 0
    
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
                
                List {
                    Button {
                        accessorySessionManager.connect()
                    } label: {
                        Text("Connect")
                    }
                    
                    LabeledContent {
                        Text(accessorySessionManager.readVoltage()?.description ?? "nil")
                    } label: {
                        Text("Battery Voltage")
                    }
                    
                    LabeledContent {
                        Text(accessorySessionManager.motorPower?.description ?? "nil")
                    } label: {
                        Text("Motor Power")
                    }
                    
                    LabeledContent {
                        Text(accessorySessionManager.readState()?.description ?? "nil")
                    } label: {
                        Text("Global State")
                    }
                    
                    TextField("Enter new state", value: $newState, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                    Button {
                        accessorySessionManager.writeState(state: UInt8(newState))
                    } label: {
                        Text("Write State")
                    }
                    
                    TextField("Enter motor torque setpoint", value: $newTorque, formatter: NumberFormatter())
                        .textFieldStyle(.roundedBorder)
                    Button {
                        accessorySessionManager.writeTorque(torque: UInt8(newTorque))
                    } label: {
                        Text("Write Torque Setpoint")
                    }
                }.scrollDisabled(true)
                
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
                            try await Task.sleep(nanoseconds: 200_000_000)
                        }
                        
                        isConnected = accessorySessionManager.peripheralConnected
                    }
                }
            
            NavigationLink(destination: SignInView()) {
                Text("Go to Pre-Workout Confirmation")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            /*NavigationLink(destination: PreWorkoutSummaryView(totalExercises: 3, workout: Workout(title: "lala", description: "lalala", iconName: "hehe", category: .fullBody, exercises: []))) {
                                Text("Go to Pre-Workout Confirmation")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding()*/
                            
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
                                        try await Task.sleep(nanoseconds: 200_000_000)
                                    }
                                    
                                    isConnected = accessorySessionManager.peripheralConnected
                                }
                            }

        }
    }


#Preview {
    PairedView(accessorySessionManager: AccessorySessionManager.shared)
}
