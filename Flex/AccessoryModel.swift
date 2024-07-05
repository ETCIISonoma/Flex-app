//
//  AccessoryModel.swift
//  Flex
//

import Foundation
import CoreBluetooth
import UIKit

enum AccessoryModel {
    case flexF1
    
    var accessoryName: String {
        switch self {
            case .flexF1: "Flex F1"
        }
    }
    
    var displayName: String {
        switch self {
            case .flexF1: "F1"
        }
    }
    
    var serviceUUID: CBUUID {
        switch self {
            case .flexF1: CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E")
        }
    }
    
    var accessoryImage: UIImage {
        switch self {
            case .flexF1: .f1Accessory
        }
    }
}
