//
//  AccessoryOrientation.swift
//  Flex
//
//  Created by Collin Cameron on 7/4/24.
//

enum AccessoryOrientation: String {
    case floor
    case wall
    case ceiling
    
    var excersiseExamples: String {
        switch self {
            case .floor: "OHT extensions, bicep curls, shoulder raise"
            case .wall: "Cable row"
            case .ceiling: "Lateral pull-down, one-arm pull-down"
        }
    }
    
    var name: String {
        return self.rawValue.capitalized
    }
}
