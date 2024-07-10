//
//  SuctionFeedbackView.swift
//  Flex
//
//  Created by Aadharsh Rajkumar on 7/9/24.
//

import SwiftUI

struct SuctionFeedbackView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Option 1 - success
                /*Image(systemName: "checkmark.circle")
                 .font(.custom("SFProDisplay-Light", size: 70))
                 .foregroundColor(.pink)*/
                
                // Option 3 - unable to attach
                Image(systemName: "viewfinder.trianglebadge.exclamationmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.pink)
                
                VStack(spacing: 10) {
                    Text("F1 was unable to attach")
                        .font(.system(size: 40))
                        .fontWeight(.medium)
                        .multilineTextAlignment(.center)
                    Text("Hold F1 very firmly to surface \n Ensure surface is non-porous")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                /*Button(action: {
                 // Your action here
                 }) {
                 Text("Try Again")
                 .foregroundColor(.white)
                 .frame(maxWidth: .infinity)
                 .padding()
                 .background(Color.pink)
                 .cornerRadius(12)
                 }
                 .padding(.horizontal, 32.5)*/
                
                NavigationLink(destination: ConfirmOrientationView(accessorySessionManager: AccessorySessionManager())) {
                    Text("Try Again")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 32.5)
            }
        }
    }
    
}

#Preview {
    SuctionFeedbackView()
}
