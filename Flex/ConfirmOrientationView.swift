//
//  ConfirmOrientationView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/5/24.
//

import Foundation
import SwiftUI

struct ConfirmOrientationView: View {
    @State private var orientation: AccessoryOrientation? = nil
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
        .navigationBarBackButtonHidden(true) // This just makes the back button visible once you click the try again button in SuctionFeedbackView. 
    }
}

struct OrientationView: View {
    let orientation: AccessoryOrientation

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

#Preview {
    ConfirmOrientationView(accessorySessionManager: AccessorySessionManager())
}
