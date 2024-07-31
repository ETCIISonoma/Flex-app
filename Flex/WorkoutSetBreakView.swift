//
//  WorkoutSetBreakView.swift
//  Flex
//
//  Created by Vaughn Khouri on 7/10/24.
//

import Foundation
import SwiftUI

struct WorkoutSetBreakView: View {
    @State private var timeRemaining: Int = 30
    @State private var timer: Timer?
    //var workout: Workout
    //@State private var navigateToHomeView = false
    
    @EnvironmentObject var targetAreas: TargetAreaStore
    //@EnvironmentObject var c: Counter
    //@EnvironmentObject var wf: workoutFlag
    
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()

                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 10)
                            .opacity(0.3)
                            .foregroundColor(Color.pink)

                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(Double(timeRemaining) / 30.0, 1.0)))
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.pink)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear, value: timeRemaining)

                        Text("\(timeRemaining)")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .frame(width: 100, height: 100)

                    Text("Set Complete")
                        .font(.title)

                    Text("Take a short break.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Spacer()
                
                Button(action: {
                    if(accessorySessionManager.wf.currentSet < 4) {
                        accessorySessionManager.wf.navigateToSetBreak = false
                        accessorySessionManager.wf.setBreakFinished = true
                        accessorySessionManager.writeState(state: 4)
                        timer?.invalidate()
                    }
                    else {
                        accessorySessionManager.wf.navigateToSetBreak = false
                        accessorySessionManager.wf.setBreakFinished = false
                        accessorySessionManager.wf.navigateToHome = true
                        accessorySessionManager.writeState(state: 4)
                        timer?.invalidate()
                    }
                }) {
                    Text("Skip")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)

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
                }
                .padding(.horizontal, 20)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            /*.navigationDestination(isPresented: $navigateToHomeView) {
                HomeView()
            }*/
            /*.navigationDestination(isPresented: $navigateToRePlaceView) {
                WorkoutRePlaceView(accessorySessionManager: accessorySessionManager).environmentObject(targetAreas)
                    .environmentObject(c)
            }*/
            .onAppear {
                startTimer()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer?.invalidate()
                DispatchQueue.main.async {
                    accessorySessionManager.wf.setBreakFinished = true
                    accessorySessionManager.wf.navigateToSetBreak = false
                    
                    if accessorySessionManager.wf.currentSet < 4 {
                        accessorySessionManager.writeState(state: 4)
                    } else {
                        accessorySessionManager.wf.navigateToHome = true
                        accessorySessionManager.writeState(state: 4)
                    }
                }
            }
        }
    }
}

struct WorkoutSetBreakView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSetBreakView()
            .environmentObject(TargetAreaStore(targetAreas: ["High", "Low", "Mid"]))
            .environmentObject(Counter(counter: 0))
            .environmentObject(workoutFlag(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false, currentSet: 1))
    }
}
