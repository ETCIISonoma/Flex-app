//
//  File.swift
//  Flex
//

/*import Foundation
import SwiftUI

struct OrientationFlowView: View {
    let accessorySessionManager: AccessorySessionManager
    
    @State private var timerFinished = false
    @State private var hasBeenClose = false
    
    var body: some View {
        if timerFinished && hasBeenClose {
            PlacementHoldView(accessorySessionManager: accessorySessionManager)
        } else {
            PlacementInstructionView()
                .onAppear {
                    startTimer()
                }
                .onChange(of: accessorySessionManager.distance) {
                    if let distance = accessorySessionManager.distance {
                        if distance < Measurement(value: 5, unit: .centimeters) {
                            withAnimation {
                                hasBeenClose = true
                            }
                        }
                    }
                }
        }
    }
    
    func startTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            withAnimation {
                timerFinished = true
            }
        }
    }
}

struct PlacementInstructionView: View {
    @State private var currentOrientationIndex = 0
    private let orientations: [AccessoryPosition] = [.floor, .wall, .ceiling]
    private let changeInterval = 4.0
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Choose any orientation to place your F1")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 250)
            
            PlayerView(
                url: Bundle.main.url(
                    forResource: "Orientations",
                    withExtension: "mp4")!,
                isTransparent: false,
                isStacked: false,
                isInverted: false,
                shouldLoop: true
            ).aspectRatio(1280/1080, contentMode: .fit)
            
            OrientationDescriptionView(orientation: orientations[currentOrientationIndex])
                .transition(.opacity)
                .frame(minHeight: 100, alignment: .top)
            
            Spacer()
        }.padding()
        .onAppear {
            startTimer()
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: changeInterval, repeats: true) { _ in
            withAnimation {
                currentOrientationIndex = (currentOrientationIndex + 1) % orientations.count
            }
        }
    }
}

struct OrientationDescriptionView: View {
    let orientation: AccessoryPosition
    
    var body: some View {
        VStack {
            Text(orientation.name.capitalized)
                .font(.title2.bold())
            Text(orientation.excersiseExamples)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: 250)
        .multilineTextAlignment(.center)
        .transition(.opacity)
    }
}

#Preview {
    PlacementInstructionView()
}*/

import SwiftUI
import Foundation

struct PlacementInstructionView: View {
    @EnvironmentObject var es: TargetAreaStore
    @EnvironmentObject var c: Counter
    @ObservedObject var accessorySessionManager: AccessorySessionManager = .shared

    var body: some View {
        switch accessorySessionManager.viewState {
            case .instruction:
                s()
                    .environmentObject(es)
                    .environmentObject(c)
            case .hold:
                PlacementHoldView()
            case .confirmation:
                PlacementConfirmationView()
            case .activeWorkout:
                WorkoutActiveView()
            case .home:
                HomeView()
            case .tryAgain:
                PlacementHoldView()
            case .replace:
                WorkoutRePlaceView()
            case .setBreak:
                WorkoutSetBreakView()
            case .remove:
                RemoveFromSurfaceView() // 3) Need to implement functionality
            case .pickUp:
                PickUpFromSurfaceView()
        }
        
        //NavigationView {
            //VStack {
                // TEST
                //Text("lol \(accessorySessionManager.readState() ?? 0)")
                
                /*if accessorySessionManager.globalState == 1 {
                 
                    //Text("lol \(accessorySessionManager.globalState ?? 0)")
                 
                    PlacementHoldView(accessorySessionManager: accessorySessionManager)
                        .environmentObject(es)
                        .environmentObject(c)*/
                    
                //} TEST else {
                    /*s()
                        .environmentObject(es)
                        .environmentObject(c)*/
                // TEST }
            //}
        //}
    }
}

struct s: View {
    @EnvironmentObject var es: TargetAreaStore
    @EnvironmentObject var c: Counter
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Option 1: High on the wall
                if es.targetAreas[c.counter] == "High" {
                    Group {
                        Text("Place your ")
                            .font(.largeTitle)
                            .foregroundColor(.white) +
                        Text("F1")
                            .font(.largeTitle)
                            .foregroundColor(.pink) +
                        Text("\nhigh on the wall")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding(.top, geometry.size.height * 0.15)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Image("high_wall_unplaced")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: geometry.size.height * 0.55)
                        .padding()
                    
                    Spacer()
                    
                    Divider()
                        .background(Color.gray)
                    
                    Text("Only attach F1 to smooth walls or hardwood.\nNever attach F1 to glass.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                
                // Option 2: Low on the Wall
                else if es.targetAreas[c.counter] == "Low" {
                    Group {
                        Text("Place your ")
                            .font(.largeTitle)
                            .foregroundColor(.white) +
                        Text("F1")
                            .font(.largeTitle)
                            .foregroundColor(.pink) +
                        Text("\nlow on the wall")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding(.top, geometry.size.height * 0.15)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Image("low_wall_unplaced")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: geometry.size.height * 0.63)
                        .padding()
                    
                    Spacer()
                    
                    Divider()
                        .background(Color.gray)
                    
                    Text("Only attach F1 to smooth walls or hardwood.\nNever attach F1 to glass.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                }
                
                // Option 3: Middle (at chest height)
                else if es.targetAreas[c.counter] == "Chest" {
                    Group {
                        Text("Place your ")
                            .font(.largeTitle)
                            .foregroundColor(.white) +
                        Text("F1")
                            .font(.largeTitle)
                            .foregroundColor(.pink) +
                        Text(" at \nchest height")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding(.top, geometry.size.height * 0.15)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Image("mid_wall_unplaced")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: geometry.size.height * 0.63)
                        .padding()
                    
                    Spacer()
                    
                    Divider()
                        .background(Color.gray)
                    
                    Text("Only attach F1 to smooth hardwood.\nNever attach F1 to glass.")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding()
                        .multilineTextAlignment(.center)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    PlacementInstructionView(accessorySessionManager: AccessorySessionManager.shared).environmentObject(TargetAreaStore(targetAreas: ["High", "Low", "Chest"]))
        .environmentObject(Counter(counter: 0))
}
