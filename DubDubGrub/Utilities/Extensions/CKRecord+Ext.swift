//
//  CKRecord+Ext.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/8/22.
//

import CloudKit

extension CKRecord {
    func convertToDDGLocation() -> DDGLocation {
        return DDGLocation(record: self)
    }
    
    
    func convertToDDGProfile() -> DDGProfile {
        return DDGProfile(record: self)
    }
}
