//
//  CKWorkoutModel.swift
//  Flex
//
//  Created by Baron Recht on 7/26/24.
//

import SwiftUI
import CloudKit
import Combine

//struct defaultValues

struct WorkoutDataModelNames {
//    static let userName = "userName"
    static let workoutCategory = "workoutCategory"
    static let date = "date"
    static let workout1Type = "workout1type"
    static let workout1Intensity = "workout1intensity"
    static let workout2Type = "workout2type"
    static let workout2Intensity = "workout2intensity"
    static let workout3Type = "workout3type"
    static let workout3Intensity = "workout3intensity"
    
    
}

struct WorkoutDataModel: Hashable, CloudKitableProtocol {
//    let userName: String// var userName: String? {
    //    return record[workoutDataModelNames.userName]
    //}
    let workoutCategory: String
    let date: Date
    let workout1Type: String
    let workout1Intensity: Int
    let workout2Type: String
    let workout2Intensity: Int
    let workout3Type: String
    let workout3Intensity: Int
    let record: CKRecord
    
    init?(record: CKRecord) {
//        guard let userName = record[workoutDataModelNames.userName] as? String else { return nil }
//        self.userName = userName
        guard let workoutCategory = record[WorkoutDataModelNames.workoutCategory] as? String else { return nil }
        self.workoutCategory = workoutCategory
        let date = Date()
        self.date = date
        
        guard let workout1Type = record[WorkoutDataModelNames.workout1Type] as? String else { return nil }
        self.workout1Type = workout1Type
       
        let workout1Intensity = record[WorkoutDataModelNames.workout1Intensity] as? Int
        self.workout1Intensity = workout1Intensity ?? 0
        
        guard let workout2Type = record[WorkoutDataModelNames.workout2Type] as? String else { return nil }
        self.workout2Type = workout2Type
       
        let workout2Intensity = record[WorkoutDataModelNames.workout2Intensity] as? Int
        self.workout2Intensity = workout2Intensity ?? 0
        
        guard let workout3Type = record[WorkoutDataModelNames.workout3Type] as? String else { return nil }
        self.workout3Type = workout3Type
       
        let workout3Intensity = record[WorkoutDataModelNames.workout3Intensity] as? Int
        self.workout3Intensity = workout3Intensity ?? 0
        
        
        self.record = record
    }
    
    init?(workoutCategory: String?) {
        let record = CKRecord(recordType: "WorkoutCategory")
        // FUTURE task: if let applied to all integer fields for type safety
        record[WorkoutDataModelNames.workoutCategory] = workoutCategory
        record[WorkoutDataModelNames.date] = Date()
        record[WorkoutDataModelNames.workout1Type] = "Cable Pull-Down, 10 reps"
        record[WorkoutDataModelNames.workout1Intensity] = 40
        record[WorkoutDataModelNames.workout1Type] = "Side Bend, 10 reps"
        record[WorkoutDataModelNames.workout1Intensity] = 30
        record[WorkoutDataModelNames.workout1Type] = "Cable Squat, 10 reps"
        record[WorkoutDataModelNames.workout1Intensity] = 45
        
        self.init(record: record)
    }
        
}

class WorkoutDataViewModel: ObservableObject {
    
    @Published var text: String = ""
    @Published var pastWorkouts: [WorkoutDataModel] = []
    var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchItems()
    }
    /*
    func addButtonPressed() {
        print("add button has been pressed")
        guard !text.isEmpty else { return }
        print("text field has text, adding item")
        
        
        
        addItem(workoutType: text)
        Task {
            await fetch()
        }
    }
    */
    
    func fetch() async {
        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000) // 3 second
       fetchItems()
    }
    
    func addItem(workoutCategory: String) {
        print("beginning addItem")
        print("attempting data write")
        do {
            guard let newWorkout = WorkoutDataModel(workoutCategory: workoutCategory) else { return }
            CloudKitUtility.add(item: newWorkout) { result in
                
            }
            
            print("finishing addItem (workout), checking workouts: \(pastWorkouts)")
        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let recordType = "WorkoutData"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                // FUTURE: Include handling of not retrieving workouts after a certain date
                self?.pastWorkouts = returnedItems
            }
            .store(in: &cancellables)
    }
    
    func fetchUserIDItems() {
        let reference = CKRecord.Reference(recordID: CloudKitUtility.personalUserID!, action: .none)
        let predicate = NSPredicate(format: "creatorUserRecordID == %@", reference)
        let recordType = "UserData"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                // FUTURE: Include handling of not retrieving workouts after a certain date
                self?.pastWorkouts = returnedItems
            }
            .store(in: &cancellables)
    }
    
    
   /*
    func deleteItem(indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        let fruit = fruits[index]
        
        CloudKitUtility.delete(item: fruit)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                print("DELETE IS: \(success)")
                self?.fruits.remove(at: index)
            }
            .store(in: &cancellables)

    }*/
    
}



/*
class UserPermissionsViewModel: ObservableObject {
    
    @Published var permissionStatus: Bool = false
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var userName: String = ""
    var cancellables = Set<AnyCancellable>()
    
    init() {
        getiCloudStatus()
        requestPermission()
        getCurrentUserName()
    }
    
    private func getiCloudStatus() {
        CloudKitUtility.getiCloudStatus()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.error = error.localizedDescription
                }
            } receiveValue: { [weak self] success in
                self?.isSignedInToiCloud = success
            }
            .store(in: &cancellables)
    }
    
    func requestPermission() {
        CloudKitUtility.requestApplicationPermission()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] success in
                self?.permissionStatus = success
            }
            .store(in: &cancellables)
    }
    
    func getCurrentUserName() {
        CloudKitUtility.discoverUserIdentity()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedName in
                self?.userName = returnedName
            }
            .store(in: &cancellables)
    }
    
}
*/
