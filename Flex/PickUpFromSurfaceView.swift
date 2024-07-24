//
//  PickUpFromSurfaceView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/23/24.
//

import SwiftUI
import Foundation

struct PickUpFromSurfaceView: View {
    
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared
    
    var body: some View {
        // 4 Need to add code to move from this to instruction view on pick up.
        VStack {
            Spacer()
            
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.pink)
            
            VStack(spacing: 10) {
                Text("Pick Up F1")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                Text("Ensure that the F1 does not contact any surface until instructed to do so")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
    }
}

#Preview {
    PickUpFromSurfaceView(accessorySessionManager: AccessorySessionManager.shared)
}
