//
//  LocationDetailVM.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/12/22.
//

import SwiftUI
import MapKit
import CloudKit

enum CheckInStatus {
    case checkedIn, checkedOut
}

final class LocationDetailVM: ObservableObject{
    
    @Published var location: DDGLocation
    @Published var column = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var alertItem : AlertItem?
    @Published var isShowingProfileModal = false

    init(location: DDGLocation){
        self.location = location
    }
    
    
    func getDirectionsToLocation() {
        let placeMark = MKPlacemark(coordinate: location.location.coordinate)
        let mapItem = MKMapItem(placemark: placeMark)
        mapItem.name = location.name
        
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking])
    }
    
    
    func callLocation(){
//        guard let url = URL(string: "tel://\(location.phoneNumber)")
        print(location.phoneNumber)
        guard let url = URL(string: "tel://\(800-444-4444)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        } else {
            //show alert or something to show that you need a phone to do this
        }
    }
    
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus){
        // Retrieve the DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            //show an alert to have them create a profile
            return
        }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) {[self] result in
            switch result{
            case .success(let record):
                // Create a reference to the location
                switch checkInStatus {
                case .checkedIn:
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                case .checkedOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                }
                // Save the updated profile to CloudKit
                CloudKitManager.shared.save(record: record) { result in
                    switch result{
                    case .success(_):
                        //update our checkedInProfile array
                        print("Checked in/out successfully")
                    case .failure(_):
                        print("Error saving record")
                    }
                }
            case .failure(_):
                print("Error fetching record")
            }
        }
    }
}
