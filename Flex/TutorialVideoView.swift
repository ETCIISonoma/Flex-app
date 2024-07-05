//
//  TutorialView.swift
//  Flex
//
//  Created by Collin Cameron on 7/4/24.
//

import SwiftUI

struct TutorialVideoView: View {
    let url: URL
    let isInReviewSheet: Bool

    private let textDelay: TimeInterval = 0.3
    private let animationDuration: TimeInterval = 4
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            
            if isInReviewSheet {
                Spacer(minLength: 28)
            }
        }
        .foregroundColor(.white)
    }
}
