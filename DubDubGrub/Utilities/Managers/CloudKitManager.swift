//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/8/22.
//

import CloudKit

final class CloudKitManager {
    
    static let shared = CloudKitManager()
    
    private init() {}
    
    var userRecord: CKRecord?
    var profileRecordID: CKRecord.ID?
    
    func getUserRecord(){
        //Get recordID
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print(error!.localizedDescription)
                return
            }
            // Get our user recordID from the container
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print(error!.localizedDescription)
                    return
                }
                self.userRecord = userRecord
                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference{
                    self.profileRecordID = profileReference.recordID
                }
            }
        }
    }
    
    
    func getCheckedInProfiles(for locationID: CKRecord.ID, completed: @escaping (Result<[DDGProfile], Error>) -> Void){
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil){records, error in
            guard let records = records, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            let profiles = records.map({$0.convertToDDGProfile()})
            completed(.success(profiles))
        }
    }
    
    
    func getCheckedInProfileDictionary(completed: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void){
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
//        operation.desiredKeys = [DDGProfile.kIsCheckedIn, DDGProfile.kAvatar] // optional to only download specific fields
        
        var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        operation.recordFetchedBlock = { record in
            //build our dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = profile.isCheckedIn else {return}
            
            checkedInProfiles[locationReference.recordID, default: []].append(profile) // if the key doesn't exist, create a default blank array
        }
        
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(checkedInProfiles))
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func getCheckedInProfilesCount(completed: @escaping (Result<[CKRecord.ID: Int], Error>) -> Void){
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = [DDGProfile.kIsCheckedIn]
        
        var checkedInProfiles: [CKRecord.ID: Int] = [:]
        operation.recordFetchedBlock = { record in
            //build our dictionary
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {return}
            
            if let count = checkedInProfiles[locationReference.recordID]{
                checkedInProfiles[locationReference.recordID] = count + 1
            } else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }
        
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(checkedInProfiles))
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void){
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            guard let records = records else { return }
            
//            var locations: [DDGLocation] = []
//
//            for record in records{
//                let location = DDGLocation(record: record)
//                locations.append(location)
//            }
            
            let locations = records.map({$0.convertToDDGLocation()})
            completed(.success(locations))
        }
    }
    
    
    
    
    func batchSave(records: [CKRecord], completed: @escaping (Result<[CKRecord], Error>) -> Void){
        
        let operation = CKModifyRecordsOperation(recordsToSave: records)
        operation.modifyRecordsCompletionBlock = { savedRecords, _, error in
            guard let savedRecords = savedRecords, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(savedRecords))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func save(record: CKRecord, completed: @escaping (Result<CKRecord, Error>) -> Void){
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(record))
        }
    }
    
    
    func fetchRecord(with id: CKRecord.ID, completed: @escaping (Result<CKRecord, Error>) -> Void){
        
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            completed(.success(record))
        }
    }
}


