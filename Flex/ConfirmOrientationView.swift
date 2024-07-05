//
//  ConfirmOrientationView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/5/24.
//

import Foundation
import SwiftUI

enum OrientationType: String {
    case floor = "f"
    case wall = "w"
    case ceiling = "c"
    case unkown = "u"
}

struct ConfirmOrientationView: View {
    @State private var orientation: OrientationType? = nil
    let accessorySessionManager: AccessorySessionManager

    var body: some View {
        VStack {
            Spacer()
            
            if let orientation = orientation {
                if orientation == .floor {
                    OrientationView(
                        imageName: "floor_image",
                        title: "Hold F1 firmly against the floor",
                        subtitle: "Ensure surface is flat and clean"
                    )
                } else if orientation == .wall {
                    OrientationView(
                        imageName: "wall_image",
                        title: "Hold F1 firmly against the wall",
                        subtitle: "Ensure surface is flat and clean"
                    )
                } else if orientation == .ceiling {
                    OrientationView(
                        imageName: "ceiling_image",
                        title: "Hold F1 firmly against the ceiling",
                        subtitle: "Ensure surface is flat and clean"
                    )
                }
            }
            Spacer()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            updateOrientation()
        }
    }
    
    func updateOrientation() {
        let distanceString = accessorySessionManager.rangefinderDistance
        let components = distanceString?.split(separator: ",")
        guard components?.count == 2, let letter = components?.last else {
            //orientation = .unknown
            return
        }

        switch letter {
        case "f":
            orientation = .floor
        case "w":
            orientation = .wall
        case "c":
            orientation = .ceiling
        default:
            orientation = .floor //Need to change to unknown later
        }
    }
}

struct OrientationView: View {
    let imageName: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 300)  // Adjust height as needed
                .padding(.bottom, 20)
            
            Text(title)
                .font(.title)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
            Text(subtitle)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ConfirmOrientationView(accessorySessionManager: AccessorySessionManager())
}
