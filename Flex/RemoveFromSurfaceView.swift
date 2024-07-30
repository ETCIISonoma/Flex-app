//
//  RemoveFromSurfaceView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/22/24.
//

import SwiftUI
import Foundation

struct RemoveFromSurfaceView: View {
    
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared
    
    //@EnvironmentObject var wf: workoutFlag
    
    var body: some View {
        VStack {
            Spacer()
            
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.pink)
            
            VStack(spacing: 10) {
                Text("Remove F1 From Surface")
                    .font(.system(size: 40))
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                Text("Press and hold the silver bar until \nall pressure is released")
                    .font(.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        
        .onAppear {
            accessorySessionManager.writeState(state: 4)
        }
    }
}

#Preview {
    RemoveFromSurfaceView(accessorySessionManager: AccessorySessionManager.shared)
        .environmentObject(workoutFlag(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false, currentSet: 1))
}
