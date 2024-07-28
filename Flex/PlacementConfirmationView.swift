//
//  SuctionFeedbackView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/9/24.
//

import SwiftUI

struct PlacementConfirmationView: View {
    
    var totalExercises: Int
    var workout: Workout
    @ObservedObject var accessorySessionManager: AccessorySessionManager = .shared
    @State private var navigateToWorkoutActiveView = false
    //@EnvironmentObject var wf: workoutFlag
    
    var body: some View {
        NavigationStack {
            VStack {
                if(accessorySessionManager.globalState.rawValue == 3) {
                    Image(systemName: "checkmark.circle")
                        .font(.custom("SFProDisplay-Light", size: 70))
                        .foregroundColor(.pink)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                navigateToWorkoutActiveView = true
                                //wf.success = true
                            }
                        }
                    
                    .navigationDestination(isPresented: $navigateToWorkoutActiveView) {
                        WorkoutActiveView(totalExercises: totalExercises, workout: workout, accessorySessionManager: accessorySessionManager)
                    }
                }
                
                else if(accessorySessionManager.globalState.rawValue == 6) {
                    Spacer()
                    
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
                    
                    // Need to change this later to no longer be navigating, just a button. 
                    NavigationLink(destination: PlacementHoldView(accessorySessionManager: accessorySessionManager)) {
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
    PlacementConfirmationView(totalExercises: 4, workout: Workout(title: "Full Body & Core - Intense", description: "Description goes here, it’s a bit \nlonger.", iconName: "flame.fill", category: .fullBody, exercises: ["Squat", "Seated Leg Curl", "Seated Leg Extension", "Crunches"]), accessorySessionManager: AccessorySessionManager.shared)
}
