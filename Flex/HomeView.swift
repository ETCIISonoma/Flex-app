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
    @StateObject var vm = WorkoutDataViewModel()
    @ObservedObject var uservm: UserViewModel = UserViewModel.shared
    
    var body: some View {
        TabView {
            Tab("Summary", systemImage: "house") {
                SummaryView()
                    .onAppear {
                        vm.addItem(workoutCategory: "Upper Body", workoutList: [
                            "Cable Pull-Down",
                            "Side Bend",
                            "Cable Squat",
                        ], intensityList: [45,35,50], timeList: [25,65,35]);
                        vm.fetchUserIDItems();
                        vm.workoutDateSorter();
                    }
            }
            
            Tab("Workouts", systemImage: "figure.strengthtraining.functional") {
                WorkoutsView()
                    .onAppear{
                        vm.workoutDateSorter();
                    }
            }
            
            Tab("Leaderboard", systemImage: "trophy") {
                LeaderboardView()
                    .onAppear{
                        vm.fetchItems()
                    }
            }
        }
    }
}

struct SummaryView: View {
    @StateObject var vm: WorkoutDataViewModel = WorkoutDataViewModel()
    @ObservedObject var uservm: UserViewModel = UserViewModel.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack{
                        Text("Welcome " + uservm.userName + "!")
                            .frame(maxWidth: .infinity)
                            .font(.largeTitle.bold())
                            //.underline(color: .pink)
                        
                        Spacer()
                    }
                    .padding(.bottom, 30)
                    MinutesGoals(vm: vm)
                    CaloriesGoal()
                }
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
    var vm: WorkoutDataViewModel
    
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
            
            NavigationLink(destination: PreWorkoutSummaryView(totalExercises: 3, workout: Workout(title: "Flex Workout of the Day", description: "Description goes here, it's a bit longer", iconName: "loll", category: .fullBody, exercises: []))) {
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
            
            NavigationLink(destination: HistoryView(vm: vm).onAppear{
                vm.pastWorkouts = vm.workoutDateSorter()
            }) {
                HStack {
                    Image(systemName: "newspaper")
                        .resizable()
                        .frame(width: 22, height: 25) // Set the size of the sparkles logo
                        .foregroundColor(.pink)
                    VStack(alignment: .leading) {
                        Text("History")
                            .foregroundColor(.white)
                            .font(.headline)
                        Text("Track Your Progress in Detail")
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

struct HistoryView: View {
    var vm: WorkoutDataViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.workoutDateSorter(), id: \.self) { workout in
                    if vm.isFromUser(workout: workout) {
                        NavigationLink(destination: WorkoutDetailView(workoutTitle: workout.workoutCategory, date: workout.dateString)) {
                            HistoryRow(workout: workout)
                        }
                        
                    }
                }
                
                /*
                
                NavigationLink(destination: WorkoutDetailView(workoutTitle: "Full Body & Core", date: "Jan 17, 2021, 4:03 PM")) {
                    HistoryRow(title: "Full Body and Core", date: "Jan 17, 2021, 4:03 PM")
                }
                NavigationLink(destination: WorkoutDetailView(workoutTitle: "Upper Body", date: "Jan 17, 2021, 4:03 PM")) {
                    HistoryRow(title: "Upper Body", date: "Jan 17, 2021, 4:03 PM")
                }
                NavigationLink(destination: WorkoutDetailView(workoutTitle: "Lower Body", date: "Jan 17, 2021, 4:03 PM")) {
                    HistoryRow(title: "Lower Body", date: "Jan 17, 2021, 4:03 PM")
                }
                
                */
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("History", displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
        }
    }
}

struct HistoryRow: View {
    var workout: WorkoutDataModel
    //var title: String
    //    var difficulty: String
    //var date: String
    
    var body: some View {
        HStack {
            Image(systemName: workoutImageIcon(workout: workout.workoutCategory))
            VStack(alignment: .leading) {
                Text(workout.workoutCategory)
                    .font(.headline)
                    .foregroundColor(.white)
                Text("Date: \(workout.date)")
                    .font(.subheadline)
                    .foregroundColor(.pink)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.pink)
        }
        .padding()
        .background(Color(UIColor.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

func workoutImageIcon(workout: String) -> String {
    print(workout)
//    let workoutE: WorkoutCategory = WorkoutCategory(rawValue: workout) ?? .fullBody
    
//    print("\(workoutE)")
    switch workout {
    case "Full Body & Core":
        return "figure.core.training"
    case "Upper Body":
        return "figure.cooldown"
    case "Lower Body":
        return "figure.cross.training"
    default:
        return "figure.core.training"
    }
}

struct WorkoutDetailView: View {
    var workoutTitle: String
    var date: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("History")
                    .foregroundColor(.pink)
                    .onTapGesture {
                        // Handle back navigation or similar
                    }
                Spacer()
            }
            .padding(.top, 10)
            
            Text(workoutTitle)
                .font(.largeTitle)
                .bold()
            
            VStack {
                HStack {
                    Text(date)
                    Spacer()
                    Text("Final Time: 17:49")
                }
                HStack{
                    Text("Workout: Complete")
                    Spacer()
                    Text("Orientation: Wall")
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            Text("Circuit")
                .font(.headline)
                .padding(.top, 10)
            
            Text("3 sets")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Exercise Rows
            List {
                ExerciseRow(imageName: "Cable Pull-Down", exerciseName: "Chest Press", details: "10 reps | Chest", intensity: 40)
                ExerciseRow(imageName: "Cable Squat", exerciseName: "Upward Woodchop", details: "10 reps | High", intensity: 35)
                ExerciseRow(imageName: "Side Bend", exerciseName: "Downward Woodchop", details: "10 reps | Low", intensity: 45)
            }
            
            Spacer()
            
            Button(action: {
                // Handle restart workout action
            }) {
                Text("Restart Workout")
                    .bold()
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
            }
        }
        .padding()
    }
}

struct ExerciseRow: View {
    var imageName: String
    var exerciseName: String
    var details: String
    var intensity: Int

    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(10)
            
            VStack(alignment: .leading) {
                Text(exerciseName)
                    .font(.headline)
                Text(details)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Avg. Intensity: \(intensity)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "info.circle")
                .foregroundColor(.red)
        }
        .padding()
    }
}

struct LeaderboardView: View {
    @StateObject var vm: WorkoutDataViewModel = WorkoutDataViewModel()
    @State private var selectedTab = 0
    private var iterator = 0

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Leaderboard")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                }
                .padding()

                Picker("", selection: $selectedTab) {
                    Text("By Streak").tag(0)
                    Text("By Active Minutes").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)

                List {
                    
                    ForEach(Array(vm.pastWorkouts.enumerated()), id: \.element) { index, workout in
                        if vm.isFromUser(workout: workout) {
                            LeaderboardRow(rank: index+1, name: "Hiroshi", detail: "274-day streak", highlight: false)
                        }
                    }
                    
                    LeaderboardRow(rank: 1, name: "Hiroshi", detail: "274-day streak", highlight: false)
                    LeaderboardRow(rank: 2, name: "Amina", detail: "213-day streak", highlight: false)
                    LeaderboardRow(rank: 3, name: "Leandro", detail: "189-day streak", highlight: true)
                    LeaderboardRow(rank: 4, name: "Nia", detail: "157-day streak", highlight: false)
                }
                .listStyle(PlainListStyle())
                .background(Color.black)
            }
            .navigationBarHidden(true)
        }
        .tabItem {
            Image(systemName: "trophy.fill")
            Text("Leaderboard")
        }
    }
}

struct LeaderboardRow: View {
    var rank: Int
    var name: String
    var detail: String
    var highlight: Bool

    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.pink)
                .frame(width: 35, alignment: .leading)
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.headline)
                        
                        Text(detail)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    if highlight {
                        Text("You")
                            .font(.callout)
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                    }
                }
                
            }
            Spacer()
        }
        .padding()
        .background(highlight ? Color.gray.opacity(0.2) : Color.clear)
        .cornerRadius(10)
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
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared
    
    var body: some View {
        VStack {
            Button(action: {
                // Set the flag to false when the button is clicked
                print("set flag in home view")
                accessorySessionManager.wf.workoutFinished = false
            }) {
                NavigationLink(destination: PreWorkoutSummaryView(totalExercises: workout.exercises.count, workout: workout)) {
                    VStack {
                        Image(systemName: workout.iconName)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: 150, height: 100)
                            .backgroundStyle(Color.init(uiColor: .tertiarySystemBackground))
                            .foregroundColor(.white)
                        
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
                }
            }
            .buttonStyle(.plain)
        }
        .onAppear {
            accessorySessionManager.wf.workoutFinished = false
            print("WorkoutTile appeared, flag set to false")
        }
        //.border(.red)
        /*NavigationLink(destination: PreWorkoutSummaryView(totalExercises: workout.exercises.count, workout: workout)) {
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
        }
        .buttonStyle(.plain)*/
    }
}

#Preview {
    HomeView()
        .environmentObject(TargetAreaStore(targetAreas: ["Chest", "High", "Low"]))
        .environmentObject(numSets(selectedSets: 3))
        .environmentObject(Counter(counter: 0))
        .environmentObject(workoutFlag(navigateToRePlace: false, navigateToSetBreak: false, navigateToHome: false, setBreakFinished: false, initialPickUp: false, workoutFinished: false, currentSet: 1))
}
