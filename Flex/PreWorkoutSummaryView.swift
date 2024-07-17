//
//  PreWorkoutSummaryView.swift
//  Flex
//
//  Created by Vaughn Khouri on 7/10/24.
//

import SwiftUI

class TargetAreaStore: ObservableObject {
    @Published var targetAreas: [String]

    init(targetAreas: [String]) {
        self.targetAreas = targetAreas
    }
}
class Counter: ObservableObject {
    @Published var counter: Int

    init(counter: Int) {
        self.counter = counter
    }
}

struct PreWorkoutSummaryView: View {
    var workout: Workout
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var environmentStore:  TargetAreaStore

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.pink)
                }
                Text("Workouts")
                    .foregroundColor(.pink)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding()
            .background(Color.black)
            
            ScrollView {
                VStack(alignment: .leading) {
                    Text(workout.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Text(workout.description)
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    HStack {
                        Text("20 min")
                            .foregroundColor(.white)
                        Spacer()
                        Text(workout.category)
                            .foregroundColor(.white)
                    }
                    .padding(.bottom, 10)
                    
                    Text("Circuit")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 5)
                    
                    Text("3 sets")
                        .foregroundColor(.gray)
                        .padding(.bottom, 10)
                    
                    VStack(spacing: 15) {
                        ExerciseRowView(exerciseName: "Chest Press", reps: "10 reps", targetIndex: environmentStore.targetAreas[0])
                        ExerciseRowView(exerciseName: "Upward Woodchop", reps: "10 reps", targetIndex: environmentStore.targetAreas[1])
                        ExerciseRowView(exerciseName: "Downward Woodchop", reps: "10 reps", targetIndex: environmentStore.targetAreas[2])
                    }
                }
                .padding()
            }
            
            Button(action: {
                // Begin workout action
            }) {
                Text("Begin Workout")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.pink)
                    .cornerRadius(10)
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .environmentObject(environmentStore)
    }
}

struct ExerciseRowView: View {
    var exerciseName: String
    var reps: String
    var targetIndex: String
    @EnvironmentObject var environmentStore: TargetAreaStore
    
    var body: some View {
        HStack {
            Image("exercise_placeholder") // Replace with your exercise image
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(10)
            VStack(alignment: .leading) {
                Text(exerciseName)
                    .foregroundColor(.white)
                Text("\(reps) | \(targetIndex)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "info.circle")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.systemGray6).opacity(0.2)) // Reduced opacity
        .cornerRadius(10)
    }
}

struct PreWorkoutSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PreWorkoutSummaryView(workout: Workout(title: "Full Body & Core - Intense", description: "Description goes here, it’s a bit longer.", iconName: "flame.fill", category: "Wall"))
            .environmentObject(TargetAreaStore(targetAreas: ["Chest", "High", "Low"]))
    }
}
