//
//  MockData.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/7/22.
//

import CloudKit

struct MockData{
    static var location: CKRecord{
        let record = CKRecord(recordType: RecordType.location)
        
        record[DDGLocation.kName] = "Steve's Subs"
        record[DDGLocation.kAddress] = "123 Main Street"
        record[DDGLocation.kDescription] = "Some cool description here. It is going to be a 3 line description to test to make sure it's truncating correctly."
        record[DDGLocation.kWebsiteURL] = "https://plavetzky.dev"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "800-444-4444"
        
        return record
    }
    
    
    static var profile: CKRecord{
        let record = CKRecord(recordType: RecordType.profile)
        
        record[DDGProfile.kFirstName] = "Super long First name"
        record[DDGProfile.kLastName] = "Super long Last Name"
        record[DDGProfile.kCompanyName] = "Super long Test company name"
        record[DDGProfile.kBio] = "This is my bio, I hope it's not too long, I can't check character counts."
        
        return record
    }
    
    
    static var chipotle: CKRecord {
        let record                          = CKRecord(recordType: RecordType.location,
                                                       recordID: CKRecord.ID(recordName: "4505E4F0-1F8B-4845-6BFB-0745145F0E79"))
        record[DDGLocation.kName]           = "Chipotle"
        record[DDGLocation.kAddress]        = "1 S Market St Ste 40"
        record[DDGLocation.kDescription]    = "Our local San Jose One South Market Chipotle Mexican Grill is cultivating a better world by serving responsibly sourced, classically-cooked, real food."
        record[DDGLocation.kWebsiteURL]     = "https://locations.chipotle.com/ca/san-jose/1-s-market-st"
        record[DDGLocation.kLocation]       = CLLocation(latitude: 37.334967, longitude: -121.892566)
        record[DDGLocation.kPhoneNumber]    = "408-938-0919"
        
        return record
    }
}
