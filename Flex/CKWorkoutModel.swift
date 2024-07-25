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
    static let workoutType = "workoutType"
    static let date = "date"
}

struct WorkoutDataModel: Hashable, CloudKitableProtocol {
//    let userName: String// var userName: String? {
    //    return record[workoutDataModelNames.userName]
    //}
    let workoutType: String
    let date: Date
    let record: CKRecord
    
    init?(record: CKRecord) {
//        guard let userName = record[workoutDataModelNames.userName] as? String else { return nil }
//        self.userName = userName
        guard let workoutType = record[WorkoutDataModelNames.workoutType] as? String else { return nil }
        self.workoutType = workoutType
        let date = Date()
        self.date = date
        self.record = record
    }
    
    init?(workoutType: String?) {
        let record = CKRecord(recordType: "WorkoutData")
        // FUTURE task: if let applied to all integer fields for type safety
        record[WorkoutDataModelNames.workoutType] = workoutType
        record[WorkoutDataModelNames.date] = Date()
        
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
    
    func addItem(workoutType: String) {
        print("beginning addItem")
        print("attempting data write")
        do {
            guard let newWorkout = WorkoutDataModel(workoutType: workoutType) else { return }
            CloudKitUtility.add(item: newWorkout) { result in
                
            }
            
            print("finishing addItem, checking workouts: \(pastWorkouts)")
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
