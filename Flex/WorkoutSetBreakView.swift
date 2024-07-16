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
    @State private var navigateToActiveView = false
    @State private var navigateToHomeView = false

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
                    navigateToHomeView = true
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
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .foregroundColor(.white)
            .navigationDestination(isPresented: $navigateToHomeView) {
                HomeView()
            }
            .navigationDestination(isPresented: $navigateToActiveView) {
                WorkoutRePlaceView()
            }
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
                navigateToActiveView = true
            }
        }
    }
}

struct WorkoutSetBreakView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutSetBreakView()
    }
}
