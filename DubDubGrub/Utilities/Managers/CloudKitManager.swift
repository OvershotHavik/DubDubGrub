//
//  CloudKitManager.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/8/22.
//

import CloudKit

struct CloudKitManager {
    static func getLocations(completed: @escaping (Result<[DDGLocation], Error>) -> Void){
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
//        CKContainer.default().publicCloudDatabase.fetch(withQuery: query) { records, error in
//        CKContainer.default().publicCloudDatabase.fetch(withQuery: query, inZoneWith: nil, desiredKeys: [DDGLocation.kName], resultsLimit: 99, completionHandler: <#T##(Result<(matchResults: [(CKRecord.ID, Result<CKRecord, Error>)], queryCursor: CKQueryOperation.Cursor?), Error>) -> Void#>)
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
}


