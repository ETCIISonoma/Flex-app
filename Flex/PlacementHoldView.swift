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
    @ObservedObject var accessorySessionManager: AccessorySessionManager = AccessorySessionManager.shared
    
    @State private var navigateToConfirmation = false
    @State private var backgroundColor = Color.black

    var body: some View {
        NavigationStack {
            if(accessorySessionManager.globalState == 3 || accessorySessionManager.globalState == 6) {
                //backgroundColor = Color.pink
                PlacementConfirmationView(accessorySessionManager: accessorySessionManager)
            }
            else {
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
                .background(backgroundColor)
                .edgesIgnoringSafeArea(.all)
            }
            /*.navigationDestination(isPresented: $navigateToConfirmation) {
                PlacementConfirmationView(accessorySessionManager: accessorySessionManager)
            }*/
        }
        
        .onAppear {
            accessorySessionManager.writeState(state: 2)
        }
        /*.onChange(of: accessorySessionManager.globalState) {
            if(accessorySessionManager.globalState == 3 || accessorySessionManager.globalState == 6) {
                navigateToConfirmation = true
                backgroundColor = Color.pink
            }
        }*/
    }
}

struct PlacementHoldView_Previews: PreviewProvider {
    static var previews: some View {
        PlacementHoldView(accessorySessionManager: AccessorySessionManager.shared)    .environmentObject(TargetAreaStore(targetAreas: ["High", "Low", "Chest"]))
            .environmentObject(Counter(counter: 0))
    }
}
