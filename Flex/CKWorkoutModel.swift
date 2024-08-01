import SwiftUI
import CloudKit
import Combine

//struct defaultValues

struct WorkoutDataModelNames {
    static let userName = "userName"
    static let userID = "userID"
    static let workoutCategory = "workoutCategory"
    static let date = "date"
    static let dateString = "dateString"
    static let workout1Type = "workout1type"
    static let workout1Intensity = "workout1intensity"
    static let workout1Time = "workout1time"
    static let workout2Type = "workout2type"
    static let workout2Intensity = "workout2intensity"
    static let workout2Time = "workout2time"
    static let workout3Type = "workout3type"
    static let workout3Intensity = "workout3intensity"
    static let workout3Time = "workout3time"
    
    
}

struct WorkoutDataModel: Hashable, CloudKitableProtocol {
//    let userName: String// var userName: String? {
    //    return record[workoutDataModelNames.userName]
    //}
    
    let userName: String
    let userID: String
    let workoutCategory: String
    let date: Date
    let dateString: String
    let workout1Type: String
    let workout1Intensity: Int
    let workout1Time: Int
    let workout2Type: String
    let workout2Intensity: Int
    let workout2Time: Int
    let workout3Type: String
    let workout3Intensity: Int
    let workout3Time: Int
    
    let record: CKRecord
    
    init?(record: CKRecord) {
//        guard let userName = record[workoutDataModelNames.userName] as? String else { return nil }
//        self.userName = userName
        guard let userName = record[WorkoutDataModelNames.userName] as? String else { return nil }
        self.userName = userName
        
        guard let userID = record[WorkoutDataModelNames.userID] as? String else { return nil }
        self.userID = userID
        
        guard let workoutCategory = record[WorkoutDataModelNames.workoutCategory] as? String else { return nil }
        self.workoutCategory = workoutCategory
        
        guard let date = record[WorkoutDataModelNames.date] as? Date else {return nil}
        self.date = date
        
        guard let dateString = record[WorkoutDataModelNames.dateString] as? String else {return nil}
        self.dateString = dateString
        
        guard let workout1Type = record[WorkoutDataModelNames.workout1Type] as? String else { return nil }
        self.workout1Type = workout1Type
       
        let workout1Intensity = record[WorkoutDataModelNames.workout1Intensity] as? Int
        self.workout1Intensity = workout1Intensity ?? 0
        
        let workout1Time = record[WorkoutDataModelNames.workout1Time] as? Int
        self.workout1Time = workout1Time ?? 0
        
        guard let workout2Type = record[WorkoutDataModelNames.workout2Type] as? String else { return nil }
        self.workout2Type = workout2Type
       
        let workout2Intensity = record[WorkoutDataModelNames.workout2Intensity] as? Int
        self.workout2Intensity = workout2Intensity ?? 0
        
        let workout2Time = record[WorkoutDataModelNames.workout2Time] as? Int
        self.workout2Time = workout2Time ?? 0
        
        guard let workout3Type = record[WorkoutDataModelNames.workout3Type] as? String else { return nil }
        self.workout3Type = workout3Type
       
        let workout3Intensity = record[WorkoutDataModelNames.workout3Intensity] as? Int
        self.workout3Intensity = workout3Intensity ?? 0
        
        let workout3Time = record[WorkoutDataModelNames.workout3Time] as? Int
        self.workout3Time = workout3Time ?? 0
        
        
        self.record = record
    }
    
    init?(workoutCategory: String?, workoutList: [String], intensityList: [Int], timeList: [Int]) {
        let record = CKRecord(recordType: "WorkoutData")
        let defaultIntensity: Int = 0
        let defaultTime: Double = 0
        // FUTURE task: if let applied to all integer fields for type safety
        
        record[WorkoutDataModelNames.userName] = UserViewModel.shared.userName
        record[WorkoutDataModelNames.userID] = UserViewModel.shared.IDString //"\(String(describing: CloudKitUtility.personalUserID))"
        record[WorkoutDataModelNames.workoutCategory] = workoutCategory
        record[WorkoutDataModelNames.date] = Date()
        record[WorkoutDataModelNames.dateString] = Date().formatted(date: .abbreviated, time: .shortened)
        
        
        if intensityList.count >= 1 {
            record[WorkoutDataModelNames.workout1Type] = workoutList[0]
            record[WorkoutDataModelNames.workout1Intensity] = intensityList[0]
        } else {
            record[WorkoutDataModelNames.workout1Type] = workoutList[0] + ": Did Not Complete"
            record[WorkoutDataModelNames.workout1Intensity] = defaultIntensity
        }
        
        if timeList.count >= 1 {
            record[WorkoutDataModelNames.workout1Time] = timeList[0]
        } else {
            record[WorkoutDataModelNames.workout1Time] = defaultTime
        }
        
        
        if intensityList.count >= 2 {
            record[WorkoutDataModelNames.workout2Type] = workoutList[1]
            record[WorkoutDataModelNames.workout2Intensity] = intensityList[1]
        } else {
            record[WorkoutDataModelNames.workout2Type] = workoutList[1] + ": Did Not Complete"
            record[WorkoutDataModelNames.workout2Intensity] = defaultIntensity
        }
        
        if timeList.count >= 2 {
            record[WorkoutDataModelNames.workout2Time] = timeList[1]
        } else {
            record[WorkoutDataModelNames.workout2Time] = defaultTime
        }
        
        if intensityList.count >= 3 {
            record[WorkoutDataModelNames.workout3Type] = workoutList[2]
            record[WorkoutDataModelNames.workout3Intensity] = intensityList[2]
        } else {
            record[WorkoutDataModelNames.workout3Type] = workoutList[2] + ": Did Not Complete"
            record[WorkoutDataModelNames.workout3Intensity] = defaultIntensity
        }
        
        if timeList.count >= 3 {
            record[WorkoutDataModelNames.workout3Time] = timeList[2]
        } else {
            record[WorkoutDataModelNames.workout3Time] = defaultTime
        }
        
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
    
    func addItem(workoutCategory: String, workoutList:[String], intensityList: [Double], timeList: [Int]) {
        print("beginning addItem (workout)")
        print("attempting data write")
        
        var intIntensityList: [Int] = []
        
        for intensity in intensityList {
            intIntensityList.append(Int(intensity))
        }
        
        do {
            guard let newWorkout = WorkoutDataModel(workoutCategory: workoutCategory, workoutList: workoutList, intensityList: intIntensityList, timeList: timeList) else { return }
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
        let sortDescriptions = [NSSortDescriptor(key: "creationDate", ascending: false)]
        let recordType = "WorkoutData"
        
        CloudKitUtility.detailedFetch(predicate: predicate, recordType: recordType, sortDescriptions: sortDescriptions)
            .receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { [weak self] returnedItems in
                // FUTURE: Include handling of not retrieving workouts after a certain date
                self?.pastWorkouts = returnedItems
            }
            .store(in: &cancellables)
        //        print("\(pastWorkouts[0].allKeys())")
        
        
    }
    
    func workoutDateSorter() -> [WorkoutDataModel] {
        var sortedArray: [WorkoutDataModel] = []
        sortedArray = self.pastWorkouts.sorted(by: { $0.date.compare($1.date) == ComparisonResult.orderedDescending})
        
        /*let isoDate = "Jul 31, 2024 at 9:30 AM"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:isoDate)! */
        
        print("\(pastWorkouts.count)")
        
        var dateArray: [Date] = []
        for workout in pastWorkouts {
            dateArray.append(workout.date)
        }
        
        var ready = dateArray.sorted(by: { $0.compare($1) == .orderedDescending })
        print("Date Array, sorted:")
        print("\(ready)")
        
        return sortedArray
    }
    
    func isFromUser(workout: WorkoutDataModel) -> Bool {
        if workout.userID.dropFirst(32) ==  UserViewModel.shared.IDString.dropFirst(32) {
         /*   print("trube")
            print("Optional(" + UserViewModel.shared.IDString + ")")
            print(UserViewModel.shared.IDString)
            print(workout.userID) */
            return true
        } else {
            
            print("flase")
            print("UVM String:" + UserViewModel.shared.IDString.dropFirst(32))
            print("")
            print("userName:" + workout.userID.dropFirst(32))
            print("")
            print(UserViewModel.shared.IDString)
             
            
            return false
        }
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
