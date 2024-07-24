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
class numSets: ObservableObject {
    @Published var selectedSets: Int
    
    init(selectedSets: Int) {
        self.selectedSets = selectedSets
    }
}
class workoutFlag: ObservableObject {
    @Published var navigateToRePlace: Bool
    @Published var navigateToSetBreak: Bool
    @Published var navigateToHome: Bool
    @Published var setBreakFinished: Bool
    @Published var initialPickUp: Bool
    @Published var workoutFinished: Bool
    
    init(navigateToRePlace: Bool, navigateToSetBreak: Bool, navigateToHome: Bool, setBreakFinished: Bool, initialPickUp: Bool, workoutFinished: Bool) {
        self.navigateToRePlace = navigateToRePlace
        self.navigateToSetBreak = navigateToSetBreak
        self.navigateToHome = navigateToHome
        self.setBreakFinished = setBreakFinished
        self.initialPickUp = initialPickUp
        self.workoutFinished = workoutFinished
    }
}

struct PreWorkoutSummaryView: View {
    var workout: Workout
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject private var environmentStore:  TargetAreaStore
    @EnvironmentObject private var sets: numSets
    @EnvironmentObject var wf: workoutFlag
    
    @State private var totalTime = 20.0
    //@State var navigate: Bool = false
    
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared
    
    let exercises = [
        "Chest Press",
        "Upward Woodchop",
        "Downward Woodchop"
    ]

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack(alignment: .leading) {
                        Text(workout.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        
                        HStack(alignment: .top) {
                            Text(workout.description)
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                                .lineLimit(2)
                                .truncationMode(.tail)
                            
                            Spacer()
                            
                            VStack(alignment: .trailing, spacing: 5) {
                                HStack {
                                    Image(systemName: "timer").foregroundColor(.white)
                                    Text("\(String(format: "%.1f", totalTime)) min")
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Image(systemName: "rectangle.portrait.rotate").foregroundColor(.white)
                                    Text(workout.category)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.bottom, 10)
                        }
                        
                        Divider()
                            .background(Color.white)
                        
                        Text("Circuit")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.bottom, 5)
                        
                        Menu {
                            ForEach(1..<6) { number in
                                Button(action: {
                                    sets.selectedSets = number
                                    totalTime = 20.0 / 3.0 * Double(sets.selectedSets)
                                }) {
                                    Text("\(number) sets")
                                }
                            }
                        } label: {
                            Text("\(sets.selectedSets) sets")
                                .foregroundColor(.pink)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white, lineWidth: 0))
                                .background(.pink.opacity(0.15))
                        }
                        .padding(.bottom, 10)
                        
                        VStack(spacing: 15) {
                            ExerciseRowView(exerciseName: exercises[0], reps: "10 reps", targetIndex: environmentStore.targetAreas[0])
                            ExerciseRowView(exerciseName: exercises[1], reps: "10 reps", targetIndex: environmentStore.targetAreas[1])
                            ExerciseRowView(exerciseName: exercises[2], reps: "10 reps", targetIndex: environmentStore.targetAreas[2])
                        }
                    }
                    .padding()
                }
                
                Button(action: {
                    //navigate = true
                    wf.workoutFinished = false
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
            /*.navigationDestination(isPresented: $navigate) {
                if(accessorySessionManager.globalState.rawValue == 0) { PlacementInstructionView(accessorySessionManager: accessorySessionManager)
                }
                else{
                    PickUpFromSurfaceView(accessorySessionManager: accessorySessionManager)
                }
            }*/
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
            /*Image("exercise_placeholder") // Replace with your exercise image
                .resizable()
                .frame(width: 60, height: 60)
                .cornerRadius(10)*/
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
        .background(Color.gray.opacity(0.25)) // Reduced opacity
        .cornerRadius(10)
    }
}

struct PreWorkoutSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        PreWorkoutSummaryView(workout: Workout(title: "Full Body & Core - Intense", description: "Description goes here, it’s a bit \nlonger.", iconName: "flame.fill", category: "Wall"))
            .environmentObject(TargetAreaStore(targetAreas: ["Chest", "High", "Low"]))
            .environmentObject(numSets(selectedSets: 3))
            .environmentObject(Counter(counter: 0))
            .environmentObject(workoutFlag(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false))
    }
}
