//
//  WorkoutRePlaceView.swift
//  Flex
//
//  Created by Vaughn Khouri on 7/10/24.
//

import Foundation
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
}
