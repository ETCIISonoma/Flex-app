//
//  HomeView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/10/24.
//

import SwiftUI

//struct HomeView: View {
//    @AppStorage("fullName") var fullName: String = ""
//    @State private var selectedTab: Tab = .summary
//    @State private var selectedWorkout: Workout? = nil
//
//    enum Tab {
//        case summary
//        case workouts
//    }
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            VStack {
//                if selectedTab == .summary {
//                    HStack {
//                        VStack(alignment: .leading) {
//                            Text("Welcome back, \(fullName)!")
//                                .foregroundColor(.white)
//                            Text("Summary")
//                                .font(.largeTitle)
//                                .fontWeight(.bold)
//                                .foregroundColor(.white)
//                        }
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color.black)
//                } else if selectedTab == .workouts {
//                    HStack {
//                        Text("Workouts")
//                            .font(.largeTitle)
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color.black)
//                }
//                
//                // Main Content
//                switch selectedTab {
//                case .summary:
//                    SummaryView()
//                case .workouts:
//                    WorkoutsView(selectedWorkout: $selectedWorkout)
//                }
//                
//                Spacer()
//            }
//            
//            HStack(spacing: 50) {
//                Button(action: {
//                    selectedTab = .summary
//                }) {
//                    VStack {
//                        Image(systemName: "house.fill")
//                            .font(.system(size: 24))
//                            .foregroundColor(selectedTab == .summary ? .pink : .gray)
//                        Text("Summary")
//                            .font(.caption)
//                            .foregroundColor(selectedTab == .summary ? .pink : .gray)
//                    }
//                }
//                Spacer()
//                Button(action: {
//                    selectedTab = .workouts
//                }) {
//                    VStack {
//                        Image(systemName: "figure.walk")
//                            .font(.system(size: 24))
//                            .foregroundColor(selectedTab == .workouts ? .pink : .gray)
//                        Text("Workouts")
//                            .font(.caption)
//                            .foregroundColor(selectedTab == .workouts ? .pink : .gray)
//                    }
//                }
//            }
//            .padding(.horizontal, 50) // Adjust padding as needed
//            .padding(.vertical)
//            .background(Color.black)
//        }
//        .edgesIgnoringSafeArea(.bottom)
//        .fullScreenCover(item: $selectedWorkout) { workout in
//            PreWorkoutSummaryView(workout: workout)
//        }
//    }
//}
//
//struct SummaryView: View {
//    @State private var legsProgress: CGFloat = 8
//    @State private var armsProgress: CGFloat = 8
//    @State private var coreProgress: CGFloat = 10
//
//    var body: some View {
//        VStack {
//            VStack(alignment: .leading) {
//                // Your daily minutes goal section
//                Text("Your daily minutes goal")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(.bottom, 10)
//                
//                HStack(spacing: 30) {
//                    VStack {
//                        ZStack {
//                            Circle()
//                                .stroke(Color.gray.opacity(0.5), lineWidth: 10)
//                                .frame(width: 70, height: 70)
//                            Circle()
//                                .trim(from: 0, to: legsProgress / 20)
//                                .stroke(Color.red, lineWidth: 10)
//                                .frame(width: 70, height: 70)
//                                .rotationEffect(.degrees(-90))
//                        }
//                        Text("Legs")
//                            .foregroundColor(.white)
//                        Text("\(Int(legsProgress)) of 20min")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    VStack {
//                        ZStack {
//                            Circle()
//                                .stroke(Color.gray.opacity(0.5), lineWidth: 10)
//                                .frame(width: 70, height: 70)
//                            Circle()
//                                .trim(from: 0, to: armsProgress / 20)
//                                .stroke(Color.green, lineWidth: 10)
//                                .frame(width: 70, height: 70)
//                                .rotationEffect(.degrees(-90))
//                        }
//                        Text("Arms")
//                            .foregroundColor(.white)
//                        Text("\(Int(armsProgress)) of 20min")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    VStack {
//                        ZStack {
//                            Circle()
//                                .stroke(Color.gray.opacity(0.5), lineWidth: 10)
//                                .frame(width: 70, height: 70)
//                            Circle()
//                                .trim(from: 0, to: coreProgress / 30)
//                                .stroke(Color.blue, lineWidth: 10)
//                                .frame(width: 70, height: 70)
//                                .rotationEffect(.degrees(-90))
//                        }
//                        Text("Core")
//                            .foregroundColor(.white)
//                        Text("\(Int(coreProgress)) of 30min")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                }
//                .frame(maxWidth: .infinity)
//                .padding(.bottom, 10)
//            }
//            .padding()
//            .background(Color.black)
//            .cornerRadius(10)
//            .padding(.horizontal)
//            
//            VStack(alignment: .leading) {
//                // Your daily calories goal section
//                Text("Your daily calories goal")
//                    .font(.title3)
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding(.bottom, 10)
//                
//                HStack {
//                    Image(systemName: "flame.fill")
//                        .foregroundColor(.pink)
//                    Text("324 / 500cal")
//                        .font(.title)
//                        .foregroundColor(.white)
//                }
//                .frame(maxWidth: .infinity, alignment: .center)
//            }
//            .padding()
//            .background(Color.black)
//            .cornerRadius(10)
//            .padding(.horizontal)
//            
//            // Suggested workout section
//            HStack {
//                Image(systemName: "sparkles")
//                    .foregroundColor(.pink)
//                VStack(alignment: .leading) {
//                    Text("Start Suggested Workout...")
//                        .foregroundColor(.white)
//                    Text("Based on your trends")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                Spacer()
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//            }
//            .padding()
//            .background(Color.black)
//            .cornerRadius(10)
//            .padding(.horizontal)
//        }
//        .padding(.leading, 15)
//        .navigationTitle("Summary")
//        .navigationBarTitleDisplayMode(.large)
//    }
//}
//
enum WorkoutCategory: String, CaseIterable {
    case upperBody
    case lowerBody
    case fullBody
    
    var name: String {
        switch self {
            case .upperBody: "Upper Body"
            case .lowerBody: "Lower Body"
            case .fullBody: "Full Body"
        }
    }
}

struct Workout: Identifiable {
    var id = UUID()
    var title: String
    var description: String
    var iconName: String
    var category: WorkoutCategory
    var exercises: [String]
}
//
//struct WorkoutsView: View {
//    @State private var selectedSegment = "Wall"
//    private let segments = ["Wall", "Floor"]
//    private let workouts = [
//        Workout(title: "Suggested Workout...", description: "Based on your trends", iconName: "sparkles", category: "Wall"),
//        Workout(title: "Full Body & Core - Intense", description: "Description goes here, it’s a bit longer.", iconName: "flame.fill", category: "Wall"),
//        Workout(title: "Upper Body - Medium", description: "Description goes here, it’s a bit longer.", iconName: "figure.walk", category: "Wall"),
//        Workout(title: "Flexibility - Relaxed", description: "Description goes here, it’s a bit longer.", iconName: "person.badge.key.fill", category: "Wall"),
//        Workout(title: "Suggested Workout...", description: "Based on your trends", iconName: "sparkles", category: "Floor"),
//        Workout(title: "Lower Body - Intense", description: "Description goes here, it’s a bit longer.", iconName: "figure.wave", category: "Floor"),
//        Workout(title: "Core Strength - High", description: "Description goes here, it’s a bit longer.", iconName: "figure.stand.line.dotted.figure.stand", category: "Floor")
//    ]
//    
//    @Binding var selectedWorkout: Workout?
//
//    var body: some View {
//        VStack {
//            TextField("Search", text: .constant(""))
//                .padding()
//                .background(Color(.tertiarySystemFill)) // Reduced opacity
//                .cornerRadius(10)
//                .padding(.horizontal)
//            
//            Picker("Select", selection: $selectedSegment) {
//                ForEach(segments, id: \.self) { segment in
//                    Text(segment).tag(segment)
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding(.horizontal)
//            
//            ScrollView {
//                VStack(spacing: 0) {
//                    // "Suggested Workout..." button
//                    ForEach(workouts.filter { $0.category == selectedSegment && $0.title == "Suggested Workout..." }) { workout in
//                        Button(action: {
//                            selectedWorkout = workout
//                        }) {
//                            HStack {
//                                Image(systemName: workout.iconName)
//                                    .foregroundColor(.pink)
//                                VStack(alignment: .leading) {
//                                    Text(workout.title)
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 20)) // Increase font size
//                                    Text(workout.description)
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding(.vertical, 10) // Increase vertical padding
//                            .padding(.horizontal) // Add horizontal padding
//                            .frame(height: 70) // Set a fixed height for the button
//                            .background(Color(.tertiarySystemFill))
//                            .cornerRadius(10)
//                        }
//                        .padding(.bottom, 10) // Add padding after the button
//                    }
//                    
//                    // Other workout buttons
//                    ForEach(workouts.filter { $0.category == selectedSegment && $0.title != "Suggested Workout..." }) { workout in
//                        Button(action: {
//                            selectedWorkout = workout
//                        }) {
//                            HStack {
//                                Image(systemName: workout.iconName)
//                                    .foregroundColor(.pink)
//                                VStack(alignment: .leading) {
//                                    Text(workout.title)
//                                        .foregroundColor(.white)
//                                        .font(.system(size: 20)) // Increase font size
//                                    Text(workout.description)
//                                        .font(.caption)
//                                        .foregroundColor(.gray)
//                                }
//                                Spacer()
//                                Image(systemName: "chevron.right")
//                                    .foregroundColor(.gray)
//                            }
//                            .padding(.vertical, 10) // Increase vertical padding
//                            .padding(.horizontal) // Add horizontal padding
//                            .frame(height: 70) // Set a fixed height for the button
//                            .background(Color(.tertiarySystemFill))
//                            .cornerRadius(10)
//                        }
//                    }
//                    
//                    Divider()
//                        .background(Color.white)
//                        .padding(.top, 12)
//                    
//                    // Text at the bottom
//                    Text(selectedSegment == "Wall" ? "Only attach F1 to smooth walls or hardwood.\nNever attach F1 to glass." : "Only attach F1 to smooth tile or hardwood.\nNever attach F1 to glass.")
//                        .font(.body)
//                        .foregroundColor(.gray)
//                        .multilineTextAlignment(.center)
//                        .padding(.top, 10) // Adjust top padding
//                        .padding(.bottom, 10) // Adjust bottom padding
//                }
//                .padding(.horizontal)
//            }
//            .background(Color.black)
//            .cornerRadius(10)
//            .padding(.bottom, 10) // Adjust bottom padding to ensure visibility of text
//        }
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}

struct HomeView: View {
    var body: some View {
        TabView {
            Tab("Summary", systemImage: "house") {
                SummaryView()
            }
            
            Tab("Workouts", systemImage: "figure.strengthtraining.functional") {
                WorkoutsView()
            }
            
            Tab("Leaderboard", systemImage: "trophy") {
                Text("Leaderboard")
            }
        }
    }
}

struct SummaryView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                MinutesGoals()
                CaloriesGoal()
            }
                .padding()
                .navigationTitle("Summary")
                .navigationBarTitleDisplayMode(.large)
                .toolbar() {
                    ToolbarItem(placement: .primaryAction){
                        Button {
                            print("Profile")
                        } label: {
                            Image(systemName: "person.circle")
                                .font(.title)
                        }
                    }
                }.toolbarTitleDisplayMode(.inlineLarge)
        }
    }
}

struct MinutesGoals: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your daily minutes goal")
                .font(.headline)
            HStack {
                MinutesGoal(name: "Legs", timeProgress: Measurement(value: 8, unit: .minutes), timeGoal: Measurement(value: 20, unit: .minutes), color: .accentColor)
                Spacer()
                MinutesGoal(name: "Arms", timeProgress: Measurement(value: 8, unit: .minutes), timeGoal: Measurement(value: 20, unit: .minutes), color: .green)
                Spacer()
                MinutesGoal(name: "Core", timeProgress: Measurement(value: 10, unit: .minutes), timeGoal: Measurement(value: 30, unit: .minutes), color: .blue)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
            
            NavigationLink(destination: PreWorkoutSummaryView(totalExercises: 3, workout: Workout(title: "Flex Workout of the Day", description: "Description goes here, it's a bit longer", iconName: "loll", category: .fullBody, exercises: ["Seated Row", "Crunches", "Bicep Curls"]))) {
                HStack {
                    Image(systemName: "sparkles")
                        .resizable()
                        .frame(width: 25, height: 25) // Set the size of the sparkles logo
                        .foregroundColor(.pink)
                    VStack(alignment: .leading) {
                        Text("Flex Workout of the Day")
                            .foregroundColor(.white)
                            .font(.headline)
                        Text("Get Started With Ease")
                            .foregroundColor(.pink)
                            .font(.subheadline)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.pink)
                }
                .padding()
                .background(Color.pink.opacity(0.15))
                .cornerRadius(12)
            }
        }
    }
}

struct MinutesGoal: View {
    let name: String
    let timeProgress: Measurement<UnitDuration>
    let timeGoal: Measurement<UnitDuration>
    let color: Color
    
    var body: some View {
        VStack {
            Gauge(value: timeProgress.converted(to: .milliseconds).value / timeGoal.converted(to: .milliseconds).value) {
                
            }.gaugeStyle(.accessoryCircularCapacity)
                .tint(color)
            Text(name)
            Text("\(Int(timeProgress.converted(to: .minutes).value.rounded(.down))) of \(timeGoal.formatted())")
                .foregroundStyle(.secondary)
        }
    }
}

struct CaloriesGoal: View {
    var body: some View {
        HStack {
            
        }
    }
}


//struct WorkoutsView: View {
//    @State private var selectedCategory: WorkoutCategory?
//    @State private var searchText = ""
//    @State private var isSearching = false
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                List(workouts.filter({ selectedCategory == nil || $0.category == selectedCategory })) {
//                    WorkoutRow(workout: $0)
//                }
//            }
//            .navigationTitle("Workouts")
//            .navigationBarTitleDisplayMode(.large)
//            .searchable(text: $searchText, isPresented: $isSearching)
//            .searchScopes($selectedCategory) {
//                Text("Upper Body").tag(WorkoutCategory.upperBody)
//                Text("Lower Body").tag(WorkoutCategory.lowerBody)
//                Text("Full Body").tag(WorkoutCategory.fullBody)
//            }
//            .onChange(of: isSearching) {
//                print(isSearching)
//                if !isSearching {
//                    selectedCategory = nil
//                }
//            }
//        }
//    }
//}

//struct WorkoutRow: View {
//    let workout: Workout
//    
//    var body: some View {
//        NavigationLink(destination: PreWorkoutSummaryView(totalExercises: workout.exercises.count, workout: workout)) {
//            HStack {
//                Image(systemName: workout.iconName)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 40, height: 30)
//                    .foregroundColor(.accentColor)
//                VStack(alignment: .leading, spacing: 3) {
//                    Text(workout.title)
//                        .foregroundColor(.primary)
//                        .font(.headline)
//                    Text(workout.description)
//                       .foregroundColor(.secondary)
//                       .font(.subheadline)
//                       .lineLimit(1)
//                }
//            }
//        }
//    }
//}

struct WorkoutsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                WorkoutCategoryView(category: .fullBody)
                WorkoutCategoryView(category: .upperBody)
                WorkoutCategoryView(category: .lowerBody)
            }
            .navigationTitle("Workouts")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct WorkoutCategoryView: View {
    let category: WorkoutCategory
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(category.name)
                .font(.title2.bold())
                .padding(.horizontal)
            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(workouts.filter({ $0.category == category })) {
                        WorkoutTile(workout: $0)
                    }
                }
                .scrollTargetLayout()
            }
            .safeAreaPadding(.horizontal)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

struct WorkoutTile: View {
    let workout: Workout
    
    var body: some View {
        NavigationLink(destination: PreWorkoutSummaryView(totalExercises: workout.exercises.count, workout: workout)) {
            VStack {
                Image(systemName: workout.iconName)
                    .resizable()
                    .scaledToFit()
                    .padding()
                    .frame(width: 150, height: 100)
                    .backgroundStyle(Color.init(uiColor: .tertiarySystemBackground))
                
                VStack(alignment: .leading) {
                    Text(workout.title)
                        .foregroundColor(.primary)
                        .font(.headline)
                    Text(workout.description)
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .lineLimit(2)
                }
                .padding()
            }
            .frame(maxWidth: 150)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(12)
        }.buttonStyle(.plain)
    }
}

#Preview {
    HomeView()
        .environmentObject(TargetAreaStore(targetAreas: ["Chest", "High", "Low"]))
        .environmentObject(numSets(selectedSets: 3))
        .environmentObject(Counter(counter: 0))
        .environmentObject(workoutFlag(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false))
}
