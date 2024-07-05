//
//  File.swift
//  Flex
//
//  Created by Collin Cameron on 7/4/24.
//

import Foundation
import SwiftUI

struct OrientationExplainationView: View {
    @State private var currentOrientationIndex = 0
    private let orientations: [AccessoryOrientation] = [.floor, .wall, .ceiling]
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
            )
            
            //OrientationDescriptionView(orientation: .floor)
            OrientationDescriptionView(orientation: orientations[currentOrientationIndex])
                .transition(.opacity)
            
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
    let orientation: AccessoryOrientation
    
    var body: some View {
        VStack {
            Text(orientation.name)
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
    OrientationExplainationView()
}
