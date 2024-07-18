//
//  ConfirmOrientationView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/5/24.
//

import Foundation
import SwiftUI

struct PlacementHoldView: View {
    @EnvironmentObject var es: TargetAreaStore
    @EnvironmentObject var c: Counter
    let accessorySessionManager: AccessorySessionManager
    
    @State private var navigateToConfirmation = false

    var body: some View {
        NavigationStack {
            VStack {
                if(es.targetAreas[c.counter] == "High") {
                    Spacer()
                    
                    Image("high_wall_placed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 281, height: 568)
                        .padding(.bottom, 11)
                        .offset(x: -25)
                    
                    HStack {
                        Text("Hold ")
                            .font(.largeTitle)
                            .foregroundColor(.white) +
                        Text("F1")
                            .font(.largeTitle)
                            .foregroundColor(.pink) +
                        Text(" firmly \nagainst the wall")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)
                    
                    Text("Ensure surface is flat and clean")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    Spacer()
                }
                
                // Option 2: Low on the Wall
                else if(es.targetAreas[c.counter] == "Low") {
                    Spacer()
                    
                    Image("low_wall_placed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 281, height: 568)
                        .padding(.bottom, 11)
                        .offset(x: -25)
                    
                    HStack {
                        Text("Hold ")
                            .font(.largeTitle)
                            .foregroundColor(.white) +
                        Text("F1")
                            .font(.largeTitle)
                            .foregroundColor(.pink) +
                        Text(" firmly \nagainst the wall")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)
                    
                    Text("Ensure surface is flat and clean")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    Spacer()
                }
                
                // Option 3: Middle (at chest height)
                else if(es.targetAreas[c.counter] == "Chest") {
                    Spacer()
                    
                    Image("mid_wall_placed")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 281, height: 568)
                        .padding(.bottom, 11)
                        .offset(x: -25)
                    
                    HStack {
                        Text("Hold ")
                            .font(.largeTitle)
                            .foregroundColor(.white) +
                        Text("F1")
                            .font(.largeTitle)
                            .foregroundColor(.pink) +
                        Text(" firmly \nagainst the wall")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 12)
                    
                    Text("Ensure surface is flat and clean")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 20)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToConfirmation) {
                PlacementConfirmationView(accessorySessionManager: AccessorySessionManager())
            }
        }
        
        
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        
        .onAppear {
            accessorySessionManager.writeState(state: 2)
        }
        .onChange(of: accessorySessionManager.globalState) {
            if(accessorySessionManager.readState()==3 || accessorySessionManager.readState() == 6) {
                navigateToConfirmation = true
            }
        }
    }
}

struct PlacementHoldView_Previews: PreviewProvider {
    static var previews: some View {
        PlacementHoldView(accessorySessionManager: AccessorySessionManager())    .environmentObject(TargetAreaStore(targetAreas: ["High", "Low", "Chest"]))
            .environmentObject(Counter(counter: 0))
    }
}
