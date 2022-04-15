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
    @Published var alertItem : AlertItem?
    @Published var isShowingProfileModal = false
    @Published var checkedInProfiles: [DDGProfile] = []
    @Published var isCheckedIn = false
    @Published var isLoading = false
    var selectedProfile: DDGProfile? {
        didSet{
            isShowingProfileModal = true
        }
    }
    
    init(location: DDGLocation){
        self.location = location
    }
    
    
    func determineColumns(for sizeCategory: ContentSizeCategory) -> [GridItem]{
        let numberOfColumns = sizeCategory >= .accessibilityMedium ? 1 : 3
        return Array(repeating: GridItem(.flexible()), count: numberOfColumns)
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
    
    
    func getCheckedInStatus(){
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {return}
        
        CloudKitManager.shared.fetchRecord(with: profileRecordID) {[self] result in
            DispatchQueue.main.async { [self] in
                switch result{
                case .success(let record):
                    if let reference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference {
//                        if reference.recordID == location.id {
//                            isCheckedIn = true
//                            print("is checked in = true")
//                        } else {
//                            isCheckedIn = false
//                            print("is checked in = false")
//                        }
                        isCheckedIn = reference.recordID == location.id
                    } else {
                        isCheckedIn = false
                        print("is checked in = false - reference is nil, not checked in anywhere")
                    }
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckedInStatus
                }
            }
        }
    }
    
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus){
        // Retrieve the DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        CloudKitManager.shared.fetchRecord(with: profileRecordID) {[self] result in
            switch result{
            case .success(let record):
                // Create a reference to the location
                switch checkInStatus {
                case .checkedIn:
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    record[DDGProfile.kIsCheckedInNilCheck] = 1
                case .checkedOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil
                }
                // Save the updated profile to CloudKit
                CloudKitManager.shared.save(record: record) {[self] result in
                    DispatchQueue.main.async { [self] in
                        switch result{
                        case .success(let record):
                            let profile = DDGProfile(record: record)
                            switch checkInStatus {
                            case .checkedIn:
                                checkedInProfiles.append(profile)
                            case .checkedOut:
                                checkedInProfiles.removeAll(where: {$0.id == profile.id})
                            }
                            //update our checkedInProfile array
                            isCheckedIn = checkInStatus == .checkedIn
                            print("Checked in/out successfully")
                        case .failure(_):
                            alertItem = AlertContext.unableToCheckInOrOut
                        }
                    }
                }
            case .failure(_):
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }
    
    
    func getCheckedInProfiles(){
        showLoadingView()
        CloudKitManager.shared.getCheckedInProfiles(for: location.id) { [self] result in
            DispatchQueue.main.async { [self] in
                switch result{
                case .success(let profiles):
                    checkedInProfiles = profiles
                case .failure(_):
                    alertItem = AlertContext.unableToGetCheckedInProfiles
                }
                hideLoadingView()
            }
        }
    }
    
    
    private func showLoadingView(){ isLoading = true}
    private func hideLoadingView(){isLoading = false}
}
