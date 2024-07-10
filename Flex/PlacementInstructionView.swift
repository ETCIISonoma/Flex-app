//
//  File.swift
//  Flex
//

import Foundation
import SwiftUI

struct OrientationFlowView: View {
    let accessorySessionManager: AccessorySessionManager
    
    @State private var timerFinished = false
    @State private var hasBeenClose = false
    
    var body: some View {
        if timerFinished && hasBeenClose {
            PlacementHoldView(accessorySessionManager: accessorySessionManager)
        } else {
            PlacementInstructionView()
                .onAppear {
                    startTimer()
                }
                .onChange(of: accessorySessionManager.distance) {
                    if let distance = accessorySessionManager.distance {
                        if distance < Measurement(value: 5, unit: .centimeters) {
                            withAnimation {
                                hasBeenClose = true
                            }
                        }
                    }
                }
        }
    }
    
    func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            withAnimation {
                timerFinished = true
            }
        }
    }
}

struct PlacementInstructionView: View {
    @State private var currentOrientationIndex = 0
    private let orientations: [AccessoryPosition] = [.floor, .wall, .ceiling]
    private let changeInterval = 4.0
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Choose any orientation to place your F1")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 250)
            
            PlayerView(
                url: Bundle.main.url(
                    forResource: "Orientations",
                    withExtension: "mp4")!,
                isTransparent: false,
                isStacked: false,
                isInverted: false,
                shouldLoop: true
            ).aspectRatio(1280/1080, contentMode: .fit)
            
            OrientationDescriptionView(orientation: orientations[currentOrientationIndex])
                .transition(.opacity)
                .frame(minHeight: 100, alignment: .top)
            
            Spacer()
        }.padding()
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: changeInterval, repeats: true) { _ in
            withAnimation {
                currentOrientationIndex = (currentOrientationIndex + 1) % orientations.count
            }
        }
    }
}

struct OrientationDescriptionView: View {
    let orientation: AccessoryPosition
    
    var body: some View {
        VStack {
            Text(orientation.name.capitalized)
                .font(.title2.bold())
            Text(orientation.excersiseExamples)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: 250)
        .multilineTextAlignment(.center)
        .transition(.opacity)
    }
}

#Preview {
    PlacementInstructionView()
}
