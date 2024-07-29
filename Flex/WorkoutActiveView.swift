//
//  WorkoutActiveView.swift
//  Flex
//
//  Created by Vaughn Khouri on 7/10/24.
//

import Foundation
import SwiftUI
import CloudKit
import Combine

struct WorkoutActiveView: View {
    @State private var timerRunning = true
    @State private var secondsElapsed = 0
    @State private var caloriesBurnt = 0
    @State private var currentSet = 1
    @State private var currentRep = 0
    @State private var timer: Timer?
    @State private var showInfo = false
    @State private var selectedExerciseInfo = ""
    // Category hardcoded currently
    @State private var selectedExerciseCategory = "Full Body & Core"
    /*@State private var navigateToHome = false
    @State private var navigateToSetBreak = false
    @State private var navigateToRePlace = false*/
    @State private var intensity: Double = 50
    
    @EnvironmentObject var c: Counter
    @EnvironmentObject var wf: workoutFlag
    
    @StateObject var vm = WorkoutDataViewModel()
    
    let totalSets = 3 //change later to take into account numSets
    let totalRepsPerSet = 10
    let totalExercises = 3
    
    let exercises = [
        ("Cable Pull-Down", "10 reps"),
        ("Side Bend", "10 reps"),
        ("Cable Squat", "10 reps")
    ]
    var workout: Workout
    
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(selectedExerciseCategory)
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("20 min - Floor")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Vaughn's F1")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("84%")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Text(timeString(time: secondsElapsed))
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    HStack(spacing: 10) {
                        Image(systemName: "flame.fill")
                            .resizable()
                            .frame(width: 24, height: 34)
                            .foregroundColor(.pink)
                        Text("\(caloriesBurnt) cal")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        timerRunning.toggle()
                        if timerRunning {
                            startTimer()
                        } else {
                            stopTimer()
                        }
                    }) {
                        Image(systemName: timerRunning ? "pause.circle.fill" : "play.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.pink)
                    }
                }
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(10)
                .padding(.horizontal)
                
                HStack {
                    ForEach(0..<totalSets, id: \.self) { index in
                        Rectangle()
                            .fill(index < currentSet-1 ? Color.pink : Color.gray.opacity(0.40))
                            .frame(height: 10)
                            .cornerRadius(5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                HStack {
                    ForEach(0..<totalRepsPerSet, id: \.self) { index in
                        Rectangle()
                            .fill(index < (currentRep % totalRepsPerSet) ? Color.pink : Color.gray.opacity(0.40))
                            .frame(height: 10)
                            .cornerRadius(5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                Text("Intensity")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                    .padding(.horizontal)
                
                HStack {
                    VStack {
                        Image(systemName: "minus.circle")
                            .foregroundColor(.white)
                        Text("0")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 10)
                    .offset(y: 8)
                    Slider(value: $intensity, in: 0...100)
                        .accentColor(.pink)
                    VStack {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.white)
                        Text("100")
                            .foregroundColor(.gray)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 10)
                    .offset(y: 8)
                }
                .padding(.horizontal)
                .onChange(of: intensity) {
                    accessorySessionManager.writeTorque(torque: UInt8(intensity))
                }
                
                Text("Circuit")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 30)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack {
                        ForEach(0..<totalExercises, id: \.self) { index in
                            HStack {
                                Image(workout.exercises[index]) // Load the corresponding image
                                    .resizable()
                                    .frame(width: 127, height: 90)
                                    .scaledToFit()
                                    .padding(.trailing, 10) // Add space between image and text

                                VStack(alignment: .leading) {
                                    Text(workout.exercises[index])
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    Text("10 Reps")
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    selectedExerciseInfo = "\(workout.exercises[index]): \(workout.exercises[index])"
                                    showInfo.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.pink)
                                }
                                .alert(isPresented: $showInfo) {
                                    Alert(
                                        title: Text("Exercise Info"),
                                        message: Text(selectedExerciseInfo),
                                        dismissButton: .default(Text("Close"))
                                    )
                                }
                            }
                            .frame(height: 100) // Height of the exercise box
                            .padding()
                            .background(.gray.opacity(0.25))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(maxHeight: 400) // Adjust max height as needed
                
                Spacer()
                
                Button(action: {
                    // End workout action
                    stopTimer()
                    // CloudKit: add item to workout history
                    vm.addItem(workoutCategory: selectedExerciseCategory)
                    // State machine
                    wf.navigateToHome = true
                    wf.workoutFinished = true
                    wf.navigateToRePlace = false
                    wf.navigateToSetBreak = false
                    wf.setBreakFinished = false
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
                .padding(.bottom)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                startTimer()
            }
            .onChange(of: currentRep) {
                if(currentRep == 10) {
                    if(c.counter == 2) {
                        c.counter = 0
                        accessorySessionManager.writeState(state: 4)
                        wf.navigateToSetBreak = true
                    }
                    else {
                        c.counter += 1
                        accessorySessionManager.writeState(state: 4)
                        wf.navigateToRePlace = true
                    }
                }
            }
            /*.navigationDestination(isPresented: $wf.navigateToHome) {
                HomeView()
            }
            .navigationDestination(isPresented: $wf.navigateToSetBreak) {
                WorkoutSetBreakView(accessorySessionManager: accessorySessionManager)
            }
            .navigationDestination(isPresented: $wf.navigateToRePlace) {
                WorkoutRePlaceView(accessorySessionManager: accessorySessionManager)
            }*/
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            secondsElapsed += 1
            // Add calories burnt calculation here.
            
            // Add code to update reps and sets
            if currentRep == totalRepsPerSet * totalExercises {
                currentRep = 0
                currentSet += 1
                if currentSet > totalSets {
                    wf.navigateToHome = true
                    wf.workoutFinished = true
                    accessorySessionManager.writeState(state: 4)
                    stopTimer()
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func timeString(time: Int) -> String {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct WorkoutActiveView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutActiveView(workout: Workout(title: "Upper Body - Relaxed", description: "insert description", iconName: "lol", category: "Upper Body", exercises: ["Cable Pull-Down", "Side Bend", "Cable Squat"]))
            .environmentObject(workoutFlag(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false))
    }
}
