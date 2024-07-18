//
//  SuctionFeedbackView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/9/24.
//

import SwiftUI

struct PlacementConfirmationView: View {
    
    let accessorySessionManager: AccessorySessionManager
    @State private var navigateToWorkoutActiveView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if(accessorySessionManager.readState() == 3) {
                    Image(systemName: "checkmark.circle")
                        .font(.custom("SFProDisplay-Light", size: 70))
                        .foregroundColor(.pink)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                navigateToWorkoutActiveView = true
                            }
                        }
                    
                    .navigationDestination(isPresented: $navigateToWorkoutActiveView) {
                        WorkoutActiveView()
                    }
                }
                
                if(accessorySessionManager.readState() == 6) {
                    Image(systemName: "viewfinder.trianglebadge.exclamationmark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.pink)
                    
                    VStack(spacing: 10) {
                        Text("F1 was unable to attach")
                            .font(.system(size: 40))
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                        Text("Hold F1 very firmly to surface \n Ensure surface is non-porous")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: PlacementHoldView(accessorySessionManager: AccessorySessionManager())) {
                        Text("Try Again")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 32.5)
                    .simultaneousGesture(TapGesture().onEnded {
                        accessorySessionManager.writeState(state: 5)
                    })
                }
            }
        }
    }
    
}

#Preview {
    PlacementConfirmationView(accessorySessionManager: AccessorySessionManager())
}
