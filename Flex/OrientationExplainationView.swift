//
//  File.swift
//  Flex
//
//  Created by Collin Cameron on 7/4/24.
//

import Foundation
import SwiftUI

struct OrientationExplainationView: View {
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
            
            OrientationDescriptionView(orientation: .floor)
            
            Spacer()
        }.padding()
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
    }
}

#Preview {
    OrientationExplainationView()
}
