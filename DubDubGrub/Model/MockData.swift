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
        record[DDGProfile.kFirstName] = "Steve"
        record[DDGProfile.kLastName] = "Plavetzky"
        record[DDGProfile.kCompanyName] = "Test company name"
        record[DDGProfile.kBio] = "This is my bio, I hope it's not too long, I can't check character counts."
        return record
    }
}
