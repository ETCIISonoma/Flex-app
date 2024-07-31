//
//  Workouts.swift
//  Flex
//
//  Created by Collin Cameron on 7/27/24.
//

import Foundation

let workouts: [Workout] = [
    Workout(
        title: "Intense",
        description: "Upper Body Intense",
        iconName: "figure.cross.training",
        category: .upperBody,
        exercises: ["Triceps Pull-Down", "Bicep Curls", "Seated Row", "Chest Press", "Shoulder Press", "Arm Raises"]
    ),
    Workout(
        title: "Relaxed",
        description: "Upper Body Relaxed",
        iconName: "figure.core.training",
        category: .upperBody,
        exercises: ["Triceps - Pull Down", "Seated Row", "Chest Press"]
    ),
    Workout(
        title: "Intense",
        description: "Lower Body Intense",
        iconName: "figure.strengthtraining.traditional",
        category: .lowerBody,
        exercises: ["Squat", "Seated Leg Curl", "Seated Leg Extension", "Crunches"]
    ),
    Workout(
        title: "Relaxed",
        description: "Lower Body Relaxed",
        iconName: "figure.strengthtraining.functional",
        category: .lowerBody,
        exercises: ["Squat", "Seated Leg Curl", "Seated Leg Extension"]
    ),
    Workout(
       title: "Relaxed",
       description: "Lower Body Relaxed",
       iconName: "figure.cross.training",
       category: .lowerBody,
       exercises: ["Squat", "Seated Leg Curl", "Seated Leg Extension"]
    ),
]
