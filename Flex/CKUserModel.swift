//
//  CKUserModel.swift
//  Flex
//
//  Created by Baron Recht on 7/25/24.
//

import SwiftUI
import CloudKit
import Combine

struct UserModelNames {
    static let userName = "userName"
    static let workoutCount = "workoutCount"
    static let minutesWorked = "minutesWorked"
}

struct UserModel: Hashable, CloudKitableProtocol {
    let userName: String// var userName: String? {
    //    return record[workoutDataModelNames.userName]
    //}
    let workoutCount: Int
    let minutesWorked: Int
    let record: CKRecord
    
    init?(record: CKRecord) {
        guard let userName = record[UserModelNames.userName] as? String else { return nil }
        self.userName = userName
        let workoutCount = record[UserModelNames.workoutCount] as? Int
        self.workoutCount = workoutCount ?? 0
        let minutesWorked = record[UserModelNames.minutesWorked] as? Int
        self.minutesWorked = minutesWorked ?? 0
        self.record = record
    }
    
    init?(userName: String, workoutCount: Int?, minutesWorked: Int?) {
        let record = CKRecord(recordType: "userData")
        record[UserModelNames.userName] = userName
        // FUTURE task: if let applied to all integer fields for type safety
        record[UserModelNames.workoutCount] = workoutCount
        record[UserModelNames.minutesWorked] = minutesWorked
        
        self.init(record: record)
    }
        
    func update(newName: String) -> UserModel? {
        let record = record
        record[UserModelNames.userName] = newName
        let returnedModel = UserModel(record: record)
        return returnedModel
    }
    
    func update(newWorkoutCount: Int, newMinutesWorked: Int) -> UserModel? {
        let record = record
        record[UserModelNames.workoutCount] = newWorkoutCount
        record[UserModelNames.minutesWorked] = newMinutesWorked
        let returnedModel = UserModel(record: record)
        return returnedModel
    }
        
}
