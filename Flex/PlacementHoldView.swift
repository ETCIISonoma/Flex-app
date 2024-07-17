//
//  ConfirmOrientationView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/5/24.
//

import Foundation
import SwiftUI

struct PlacementHoldView: View {
    @State private var orientation: AccessoryPosition? = nil
    let accessorySessionManager: AccessorySessionManager

    var body: some View {
        VStack {
            Spacer()
            
            if let orientation = orientation {
                OrientationView(orientation: orientation)
            }
            Spacer()
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            orientation = accessorySessionManager.orientation
        }
    }
}

struct OrientationView: View {
    let orientation: AccessoryPosition

    var body: some View {
        VStack {
            Image(orientation.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: 300)  // Adjust height as needed
                .padding(.bottom, 20)
            
            Text("Hold F1 firmly against the \(orientation.name)")
                .font(.title)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 5)
            
            Text("Ensure surface is flat and clean")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal)
    }
}

struct PlacementHoldView_Previews: PreviewProvider {
    static var previews: some View {
        PlacementHoldView(accessorySessionManager: AccessorySessionManager())
    }
}
