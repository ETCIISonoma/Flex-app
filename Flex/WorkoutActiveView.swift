//
//  WorkoutActiveView.swift
//  Flex
//
//  Created by Vaughn Khouri on 7/10/24.
//

import Foundation
import SwiftUI

struct WorkoutActiveView: View {
    @State private var timerRunning = true
    @State private var secondsElapsed = 0
    @State private var caloriesBurnt = 0
    //@State private var currentSet = 1
    @State private var currentRep = 0
    @State private var timer: Timer?
    @State private var showInfo = false
    @State private var selectedExerciseInfo = ""
    /*@State private var navigateToHome = false
    @State private var navigateToSetBreak = false
    @State private var navigateToRePlace = false*/
    @State private var intensity: Double = 50
    
    //@EnvironmentObject var c: Counter
    //@EnvironmentObject var wf: workoutFlag
    
    let totalSets = 3 //change later to take into account numSets
    let totalRepsPerExercise = 10
    //let totalExercises = 3
    var totalExercises: Int
    
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
                        Text("Full Body & Core")
                            .font(.headline)
                            .foregroundColor(.white)
                        Text("20 min - Floor")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Vaughn's F1")
                        BatteryPercentageView(percentage: 84)
                    }
                }
                .padding()
                
                Spacer()
                
                HStack {
                    Text(timeString(time: secondsElapsed) ?? "")
                        .contentTransition(.numericText())
                        .monospacedDigit()
                        .font(.largeTitle)
                        .foregroundColor(.white)
                    
                    Divider()
                        .frame(maxHeight: 40)
                        .padding([.horizontal], 7)
                    
                    HStack(spacing: 10) {
                        Image(systemName: "flame.fill")
                            .resizable()
                            .frame(width: 24, height: 34)
                            .foregroundColor(.accentColor)
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
                        Image(systemName: timerRunning ? "pause.fill" : "play")
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.extraLarge)
                    .buttonBorderShape(.circle)
                    .tint(.accentColor)
                }
                .padding()
                .background(.gray.opacity(0.25))
                .cornerRadius(10)
                .padding(.horizontal)
                
                HStack {
                    ForEach(0..<totalSets, id: \.self) { index in
                        Rectangle()
                            .fill(index < (accessorySessionManager.wf.currentSet-1) ? Color.pink : Color.gray.opacity(0.40))
                            .frame(height: 10)
                            .cornerRadius(5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                HStack {
                    ForEach(0..<totalRepsPerExercise, id: \.self) { index in
                        Rectangle()
                            .fill(index < (currentRep % totalRepsPerExercise) ? Color.pink : Color.gray.opacity(0.40))
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
                        Button(action: {
                            intensity = max(intensity - 10, 0)
                        }) {
                            Image(systemName: "minus.circle")
                                .foregroundColor(.pink)
                        }
                        Text("0")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 10)
                    .offset(y: 6)
                    
                    VStack {
                        Slider(value: $intensity, in: 0...100)
                            .accentColor(.pink)
                        
                        HStack {
                            ForEach(0..<6) { index in
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: 2, height: 10)
                                if index < 5 {
                                    Spacer()
                                }
                            }
                        }
                        .padding(.top, -22)
                    }
                    VStack {
                        Button(action: {
                            intensity = min(intensity + 10, 100) 
                        }) {
                            Image(systemName: "plus.circle")
                                .foregroundColor(.pink)
                        }
                        Text("100")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    .padding(.horizontal, 10)
                    .offset(y: 6)
                }
                .padding(.horizontal)
                .onChange(of: intensity) {
                    print(intensity/100*40)
                    accessorySessionManager.writeTorque(torque: UInt8((intensity/100)*40))
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
                                    stopTimer()
                                    
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
                .padding(.bottom)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .onAppear {
                startTimer()
            }
            .onChange(of: currentRep) {
                if(currentRep == 10 && accessorySessionManager.c.counter < totalExercises-1) {
                    print(accessorySessionManager.c.counter)
                    accessorySessionManager.c.counter += 1
                    print(accessorySessionManager.c.counter)
                    accessorySessionManager.writeState(state: 4)
                    accessorySessionManager.wf.navigateToRePlace = true
                    print("got to replace")
                    print(accessorySessionManager.wf.navigateToRePlace)
                }
                else if (currentRep == 10 && accessorySessionManager.c.counter >= totalExercises-1) {
                    accessorySessionManager.c.counter = 0
                    accessorySessionManager.wf.currentSet += 1
                    if accessorySessionManager.wf.currentSet > totalSets {
                        accessorySessionManager.wf.navigateToHome = true
                        accessorySessionManager.wf.workoutFinished = true
                        accessorySessionManager.writeState(state: 4)
                        stopTimer()
                        accessorySessionManager.wf.currentSet = 0
                    }
                    else {
                        accessorySessionManager.writeState(state: 4)
                        accessorySessionManager.wf.navigateToSetBreak = true
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
            withAnimation {
                secondsElapsed += 1
            }
            // Add calories burnt calculation here.
            
            // Add code to update reps and sets
            currentRep = Int(accessorySessionManager.repCount ?? 0)
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func timeString(time: Int) -> String? {
        let minutes = time / 60
        let seconds = time % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct BatteryPercentageView: View {
    let percentage: UInt8
    
    var body: some View {
        HStack(spacing: 2) {
            Text("\(percentage)%")
                .font(.callout)
                .contentTransition(.numericText(value: Double(percentage)))
            
            Image(systemName: symbol)
        }
        .foregroundColor(percentage > 20 ? .gray : .red)
    }
    
    private var symbol: String {
        switch percentage {
            case 0: "battery.0percent"
            case 1...37: "battery.25percent"
            case 38...62: "battery.50percent"
            case 63...99: "battery.75percent"
            case 100...: "battery.100percent"
            default: "battery.0percent"
        }
    }
}

struct WorkoutActiveView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutActiveView(totalExercises: 3, workout: Workout(title: "Upper Body - Relaxed", description: "insert description", iconName: "lol", category: .upperBody, exercises: ["Triceps - Pull Down", "Side Bend", "Squat"]))
            .environmentObject(workoutFlag(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false, currentSet: 1))
            .environmentObject(Counter(counter: 0))
    }
}
