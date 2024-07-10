//
//  HomeView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/10/24.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("fullName") var fullName: String = ""
    @State private var selectedTab: Tab = .summary

    enum Tab {
        case summary
        case workouts
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome back, \(fullName)!")
                            .foregroundColor(.white)
                        Text("Summary")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
                .padding()
                .background(Color.black)
                
                // Main Content
                switch selectedTab {
                case .summary:
                    SummaryView()
                case .workouts:
                    WorkoutsView()
                }
                
                Spacer()
            }
            
            HStack(spacing: 50) {
                Button(action: {
                    selectedTab = .summary
                }) {
                    VStack {
                        Image(systemName: "house.fill")
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == .summary ? .pink : .gray)
                        Text("Summary")
                            .font(.caption)
                            .foregroundColor(selectedTab == .summary ? .pink : .gray)
                    }
                }
                Spacer()
                Button(action: {
                    selectedTab = .workouts
                }) {
                    VStack {
                        Image(systemName: "figure.walk")
                            .font(.system(size: 24))
                            .foregroundColor(selectedTab == .workouts ? .pink : .gray)
                        Text("Workouts")
                            .font(.caption)
                            .foregroundColor(selectedTab == .workouts ? .pink : .gray)
                    }
                }
            }
            .padding(.horizontal, 50) // Adjust padding as needed
            .padding(.vertical)
            .background(Color.black)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct SummaryView: View {
    @State private var legsProgress: CGFloat = 8
    @State private var armsProgress: CGFloat = 8
    @State private var coreProgress: CGFloat = 10
    // These will need to be continuously updated.

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                // Your daily minutes goal section
                Text("Your daily minutes goal")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                HStack(spacing: 30) {
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 10)
                                .frame(width: 70, height: 70)
                            Circle()
                                .trim(from: 0, to: legsProgress / 20)
                                .stroke(Color.red, lineWidth: 10)
                                .frame(width: 70, height: 70)
                                .rotationEffect(.degrees(-90))
                        }
                        Text("Legs")
                            .foregroundColor(.white)
                        Text("\(Int(legsProgress)) of 20min")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 10)
                                .frame(width: 70, height: 70)
                            Circle()
                                .trim(from: 0, to: armsProgress / 20)
                                .stroke(Color.green, lineWidth: 10)
                                .frame(width: 70, height: 70)
                                .rotationEffect(.degrees(-90))
                        }
                        Text("Arms")
                            .foregroundColor(.white)
                        Text("\(Int(armsProgress)) of 20min")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    VStack {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 10)
                                .frame(width: 70, height: 70)
                            Circle()
                                .trim(from: 0, to: coreProgress / 30)
                                .stroke(Color.blue, lineWidth: 10)
                                .frame(width: 70, height: 70)
                                .rotationEffect(.degrees(-90))
                        }
                        Text("Core")
                            .foregroundColor(.white)
                        Text("\(Int(coreProgress)) of 30min")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 10)
            }
            .padding()
            .background(Color.black)
            .cornerRadius(10)
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                // Your daily calories goal section
                Text("Your daily calories goal")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                
                HStack {
                    Image(systemName: "flame.fill")
                        .foregroundColor(.pink)
                    Text("324 / 500cal")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding()
            .background(Color.black)
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Suggested workout section
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.pink)
                VStack(alignment: .leading) {
                    Text("Start Suggested Workout...")
                        .foregroundColor(.white)
                    Text("Based on your trends")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.black)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .padding(.leading, 15)
    }
}

struct WorkoutsView: View {
    var body: some View {
        Text("Workouts View")
            .foregroundColor(.white)
    }
}

#Preview {
    HomeView()
}
