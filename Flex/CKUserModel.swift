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
        let record = CKRecord(recordType: "UserData")
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

class UserViewModel: ObservableObject {
    
    @Published var permissionStatus: Bool = false
    @Published var isSignedInToiCloud: Bool = false
    @Published var personalUserID: CKRecord.ID? = nil
    @Published var error: String = ""
    @Published var userName: String = ""
    var cancellables = Set<AnyCancellable>()
    
    @Published var text: String = ""
    @Published var users: [UserModel] = []
    
    init() {
        getiCloudStatus()
        setCurrentUserID()
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
    
    func addUser() {
        requestPermission()
        
        Task{
            await setUser()
        }
    }

    func setUser() async {
        try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 second
        getCurrentUserName()
        
        try? await Task.sleep(nanoseconds: 1 * 1_000_000_000) // 1 second
        addItem(userName: userName)
    }

    func setCurrentUserID() {
        CloudKitUtility.fetchUserRecordID { fetchCompletion in
            switch fetchCompletion {
            case .success(let recordID):
                self.personalUserID = recordID
            case .failure(let error):
                print(error)
//                completion(.failure(error))
            }
        }
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
    
    func addItem(userName: String) {
        print("beginning addItem")
        print("attempting data write")
        do {
            guard let newUser = UserModel(userName: userName, workoutCount: 0, minutesWorked: 0) else { return }
            CloudKitUtility.add(item: newUser) { result in
                
            }
            
            print("finishing addItem (user), checking users: \(users)")
        }
    }
    
    func fetchItems() {
        let predicate = NSPredicate(value: true)
        let recordType = "UserData"
        CloudKitUtility.fetch(predicate: predicate, recordType: recordType)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                // FUTURE: Include handling of not retrieving workouts after a certain date
                self?.users = returnedItems
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
                self?.users = returnedItems
            }
            .store(in: &cancellables)
    }
}
