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
    let container = CKContainer.default()
    
    
    func getUserRecord() async throws{
        let recordID = try await container.userRecordID()
        let record = try await container.publicCloudDatabase.record(for: recordID)
        userRecord = record
        if let profileReference = record["userProfile"] as? CKRecord.Reference{
            profileRecordID = profileReference.recordID
        }
    }
    
    
    func getLocations() async throws -> [DDGLocation] {
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap({_, result in try? result.get()})
        //In match results, compact map, which filters out the nils, for each result, try result.get, which returns the success values as a throwing expression.
        //if it can't get the record, it will just get a nil, but the nil's are being cleared out with compact map, so we won't get the nil's
        return records.map(DDGLocation.init)
    }
    
    
    func getCheckedInProfiles(for locationID: CKRecord.ID) async throws -> [DDGProfile]{
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        let (matchResults, _) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap({_, result in try? result.get()})
        return records.map(DDGProfile.init)
    }
    
    
    func getCheckedInProfileDictionary() async throws -> [CKRecord.ID: [DDGProfile]]{
        print("✅ Network call fired off")
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        
        let (matchResults, cursor) = try await container.publicCloudDatabase.records(matching: query)
        let records = matchResults.compactMap({_, result in try? result.get()})
        
        for record in records{
            //build our dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {continue}
            checkedInProfiles[locationReference.recordID, default: []].append(profile) // if the key doesn't exist, create a default blank array
        }
        print("1️⃣ CheckedInProfiles Count = \(checkedInProfiles.count)")
        guard let cursor = cursor else { return checkedInProfiles }
        
        do {
            return try await continueWithCheckedInProfileDictionary(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
            throw error
        }
    }
    
    
    private func continueWithCheckedInProfileDictionary(cursor: CKQueryOperation.Cursor,
                                                dictionary: [CKRecord.ID: [DDGProfile]]) async throws -> [CKRecord.ID: [DDGProfile]]{
        var checkedInProfiles = dictionary
        
        let (matchResults, cursor) = try await container.publicCloudDatabase.records(continuingMatchFrom: cursor)
        let records = matchResults.compactMap({_, result in try? result.get()})
        for record in records{
            //build our dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {continue}
            checkedInProfiles[locationReference.recordID, default: []].append(profile) // if the key doesn't exist, create a default blank array
        }
        print("⭕️ recursive CheckedInProfiles Count = \(checkedInProfiles.count)")
        guard let cursor = cursor else {return checkedInProfiles}
        do {
            return try await continueWithCheckedInProfileDictionary(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
            throw error
        }
    }
    
    
    func getCheckedInProfilesCount() async throws -> [CKRecord.ID: Int]{
        print("✅ Network call fired off")
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        var checkedInProfiles: [CKRecord.ID: Int] = [:]
        let (matchResults, cursor) = try await container.publicCloudDatabase.records(matching: query,
                                                                                     desiredKeys: [DDGProfile.kIsCheckedIn])
        
        let records = matchResults.compactMap({_, result in try? result.get()})
        
        for record in records{
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {continue}
            if let count = checkedInProfiles[locationReference.recordID]{
                checkedInProfiles[locationReference.recordID] = count + 1
            } else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }

        print("1️⃣ CheckedInProfiles Count = \(checkedInProfiles.count)")
        guard let cursor = cursor else { return checkedInProfiles }
        
        do {
            return try await continueWithCheckedInProfileCount(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
            throw error
        }
    }
    
    
    private func continueWithCheckedInProfileCount(cursor: CKQueryOperation.Cursor,
                                                dictionary: [CKRecord.ID: Int]) async throws -> [CKRecord.ID: Int]{
        var checkedInProfiles = dictionary
        
        let (matchResults, cursor) = try await container.publicCloudDatabase.records(continuingMatchFrom: cursor)
        let records = matchResults.compactMap({_, result in try? result.get()})
        for record in records{
            //build our dictionary
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {continue}
            if let count = checkedInProfiles[locationReference.recordID]{
                checkedInProfiles[locationReference.recordID] = count + 1
            } else {
                checkedInProfiles[locationReference.recordID] = 1
            }
        }
        print("⭕️ recursive CheckedInProfiles Count = \(checkedInProfiles.count)")
        guard let cursor = cursor else {return checkedInProfiles}
        do {
            return try await continueWithCheckedInProfileCount(cursor: cursor, dictionary: checkedInProfiles)
        } catch {
            throw error
        }
    }
    
    
    func batchSave(records: [CKRecord]) async throws -> [CKRecord]{
        let (savedResult, _) = try await container.publicCloudDatabase.modifyRecords(saving: records, deleting: [])
        return savedResult.compactMap({_, result in try? result.get()})
    }
    
    
    func save(record: CKRecord) async throws -> CKRecord{
        return try await container.publicCloudDatabase.save(record)
    }
    
    
    func fetchRecord(with id: CKRecord.ID) async throws -> CKRecord{
        return try await container.publicCloudDatabase.record(for: id)
    }
    /*
     old way, keeping for reference with the completion handlers
     
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
            let profiles = records.map(DDGProfile.init)
            completed(.success(profiles))
        }
    }
    
    
    func getCheckedInProfileDictionary(completed: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void){
        print("✅ Network call fired off")
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
//        operation.resultsLimit = 1
//        operation.desiredKeys = [DDGProfile.kIsCheckedIn, DDGProfile.kAvatar] // optional to only download specific fields
        var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        
        operation.recordFetchedBlock = { record in
            //build our dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {return}
            checkedInProfiles[locationReference.recordID, default: []].append(profile) // if the key doesn't exist, create a default blank array
        }
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            if let cursor = cursor{
                print("1️⃣ initial cursor is not nil = \(cursor)")
                print("👨‍👩‍👧‍👦 current dictionary:  = \(checkedInProfiles)")
                self.continueWithCheckedInProfileDictionary(Cursor: cursor, dictionary: checkedInProfiles) { result in
                    switch result{
                    case .success(let profiles):
                        print("🙂1️⃣ initial success dictionary = \(profiles)")
                        completed(.success(profiles))
                    case .failure(let error):
                        print("❌ initial error = \(error.localizedDescription)")
                        completed(.failure(error))
                    }
                }
            } else {
                completed(.success(checkedInProfiles))
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func continueWithCheckedInProfileDictionary(Cursor: CKQueryOperation.Cursor,
                                                dictionary: [CKRecord.ID: [DDGProfile]],
                                                completed: @escaping (Result<[CKRecord.ID: [DDGProfile]], Error>) -> Void){
        var checkedInProfiles = dictionary
        let operation = CKQueryOperation(cursor: Cursor)
//        operation.resultsLimit = 1
        operation.recordFetchedBlock = { record in
            //build our dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else {return}
            checkedInProfiles[locationReference.recordID, default: []].append(profile) // if the key doesn't exist, create a default blank array
        }
        operation.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            if let cursor = cursor{
                print("⭕️ recursive cursor is not nil = \(cursor)")
                print("👨‍👩‍👧‍👦 current dictionary:  = \(checkedInProfiles)")
                self.continueWithCheckedInProfileDictionary(Cursor: cursor, dictionary: checkedInProfiles) { result in
                    switch result{
                    case .success(let profiles):
                        print("🙂⭕️ recursive success dictionary = \(profiles)")
                        completed(.success(profiles))
                    case .failure(let error):
                        print("❌ recursive error = \(error.localizedDescription)")
                        completed(.failure(error))
                    }
                }
            } else {
                completed(.success(checkedInProfiles))
            }
            completed(.success(checkedInProfiles))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func getCheckedInProfilesCount(completed: @escaping (Result<[CKRecord.ID: Int], Error>) -> Void){
        print("✅ Network call fired off")
        let predicate = NSPredicate(format: "isCheckedInNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = [DDGProfile.kIsCheckedIn]
//        operation.resultsLimit = 1
        
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
            if let cursor = cursor{
                print("1️⃣ initial cursor is not nil = \(cursor)")
                print("👨‍👩‍👧‍👦 current dictionary:  = \(checkedInProfiles)")
                self.continueWithCheckedInProfileCount(Cursor: cursor, dictionary: checkedInProfiles) { result in
                    switch result{
                    case .success(let profiles):
                        print("🙂1️⃣ initial success dictionary = \(profiles)")
                        completed(.success(profiles))
                    case .failure(let error):
                        print("❌ initial error = \(error.localizedDescription)")
                        completed(.failure(error))
                    }
                }
            } else {
                completed(.success(checkedInProfiles))
            }
//            completed(.success(checkedInProfiles))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    
    func continueWithCheckedInProfileCount(Cursor: CKQueryOperation.Cursor,
                                           dictionary: [CKRecord.ID: Int],
                                           completed: @escaping (Result<[CKRecord.ID: Int], Error>) -> Void){
        var checkedInProfiles = dictionary
        let operation = CKQueryOperation(cursor: Cursor)
//        operation.resultsLimit = 1
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
            if let cursor = cursor{
                print("⭕️ recursive cursor is not nil = \(cursor)")
                print("👨‍👩‍👧‍👦 current dictionary:  = \(checkedInProfiles)")
                self.continueWithCheckedInProfileCount(Cursor: cursor, dictionary: checkedInProfiles) { result in
                    switch result{
                    case .success(let profiles):
                        print("🙂⭕️ recursive success dictionary = \(profiles)")
                        completed(.success(profiles))
                    case .failure(let error):
                        print("❌ recursive error = \(error.localizedDescription)")
                        completed(.failure(error))
                    }
                }
            } else {
                completed(.success(checkedInProfiles))
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
            guard let records = records, error == nil else {
                print(error!.localizedDescription)
                completed(.failure(error!))
                return
            }
            let locations = records.map(DDGLocation.init)
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
     */
}


