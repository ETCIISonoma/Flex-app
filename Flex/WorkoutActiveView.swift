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
    @State private var currentSet = 1
    @State private var currentRep = 0
    @State private var timer: Timer?
    @State private var showInfo = false
    @State private var selectedExerciseInfo = ""
    @State private var navigateToHome = false
    
    @EnvironmentObject var c: Counter
    
    let totalSets = 3
    let totalRepsPerSet = 10
    let totalExercises = 3
    
    let exercises = [
        ("Cable Pull-Down", "10 reps"),
        ("Side Bend", "10 reps"),
        ("Cable Squat", "10 reps")
    ]
    
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
                            .fill(index < currentSet ? Color.pink : Color.gray.opacity(0.40))
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
                                Image(exercises[index].0) // Load the corresponding image
                                    .resizable()
                                    .frame(width: 127, height: 90)
                                    .scaledToFit()
                                    .padding(.trailing, 10) // Add space between image and text

                                VStack(alignment: .leading) {
                                    Text(exercises[index].0)
                                        .font(.title3)
                                        .foregroundColor(.white)
                                    Text(exercises[index].1)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    selectedExerciseInfo = "\(exercises[index].0): \(exercises[index].1)"
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
                    navigateToHome = true
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
                    }
                    else {
                        c.counter += 1
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
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
        WorkoutActiveView()
    }
}
