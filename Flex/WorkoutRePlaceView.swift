//
//  WorkoutRePlaceView.swift
//  Flex
//
//  Created by Vaughn Khouri on 7/10/24.
//

/*import Foundation
import SwiftUI

struct WorkoutRePlaceView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Spacer()

                VStack(spacing: 10) {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.pink)

                    Text("Time to re-place \nF1")
                        .font(.title)
                        .multilineTextAlignment(.center)

                    Text("Press the red button to release \nF1. Then tap continue.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                VStack(spacing: 20) {
                    Button(action: {
                        path.append(Destination.placementInstruction)
                    }) {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 50)

                    Button(action: {
                        path.append(Destination.home)
                    }) {
                        Text("End Workout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink.opacity(0.15))
                            .foregroundColor(.pink)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 50)
                }
                .padding(.bottom, 50)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .placementInstruction:
                    PlacementInstructionView(accessorySessionManager: AccessorySessionManager())
                case .home:
                    HomeView()
                }
            }
            .navigationBarHidden(true) // Hide the navigation bar back button
        }
    }
}

enum Destination: Hashable {
    case placementInstruction
    case home
}



struct WorkoutRePlaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRePlaceView()
    }
}*/

import SwiftUI

struct WorkoutRePlaceView: View {
    @State private var showPlacementInstruction = false
    @State private var showHomeView = false
    @EnvironmentObject var targetAreas: TargetAreaStore
    //@EnvironmentObject var c: Counter
    //@EnvironmentObject var wf: workoutFlag
    
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                VStack(spacing: 10) {
                    Image(systemName: "arrow.up.arrow.down")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.pink)

                    Text("Time to re-place \nF1")
                        .font(.title)
                        .multilineTextAlignment(.center)

                    Text("Press the silver bar to release the F1.\n Then lift it.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                VStack(spacing: 20) {
                    /*NavigationLink(
                        destination: PlacementInstructionView(accessorySessionManager: accessorySessionManager) .environmentObject(targetAreas)
                            .environmentObject(c)
                    )
                   
                    {
                        Text("Continue")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 50)*/

                    Button(action: {
                        accessorySessionManager.wf.navigateToHome = true
                        accessorySessionManager.wf.workoutFinished = true
                        accessorySessionManager.wf.navigateToRePlace = false
                        accessorySessionManager.wf.navigateToSetBreak = false
                        accessorySessionManager.wf.setBreakFinished = false
                        accessorySessionManager.writeState(state: 4)
                    }) {
                        Text("End Workout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink.opacity(0.15))
                            .foregroundColor(.pink)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.horizontal, 2)
                    
                    /*NavigationLink(
                        destination: HomeView()) {
                        Text("End Workout")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pink.opacity(0.15))
                            .foregroundColor(.pink)
                            .cornerRadius(12)
                    
                    }
                    .padding(.horizontal, 50)*/
                }
                .padding(.bottom, 50)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            
            /* TEST .navigationDestination(isPresented: $showPlacementInstruction) {
                PlacementInstructionView(accessorySessionManager: accessorySessionManager)
            }*/
        }
        
        /*.onAppear {
            accessorySessionManager.writeState(state: 4)
        }*/
        
        /* TEST .onChange(of: accessorySessionManager.globalState) {
            if(accessorySessionManager.globalState == 0) {
                showPlacementInstruction = true
            }
        }*/
    }
}

struct WorkoutRePlaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutRePlaceView(accessorySessionManager: AccessorySessionManager.shared)
            .environmentObject(TargetAreaStore(targetAreas: ["High", "Low", "Mid"]))
            .environmentObject(Counter(counter: 0))
    }
}
