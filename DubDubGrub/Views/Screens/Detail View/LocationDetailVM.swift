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

@MainActor final class LocationDetailVM: ObservableObject{
    
    @Published var location: DDGLocation
    @Published var alertItem : AlertItem?
    @Published var isShowingProfileModal = false
    @Published var isShowingProfileSheet = false
    @Published var checkedInProfiles: [DDGProfile] = []
    @Published var isCheckedIn = false
    @Published var isLoading = false
    var selectedProfile: DDGProfile?
    var buttonCOlor: Color{
        isCheckedIn ? .grubRed : .brandPrimary
    }
    var buttonImageTitle: String{
        isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark"
    }
    var buttonA11yLabel: String{
        isCheckedIn ? "Check out of location." : "Check into location."
    }
    
    init(location: DDGLocation){
        self.location = location
    }
    
    
    func determineColumns(for dynamicTypeSize: DynamicTypeSize) -> [GridItem]{
        let numberOfColumns = dynamicTypeSize >= .accessibility3 ? 1 : 3
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
//        guard let url = URL(string: "tel://\(800-444-4444)") else {
        guard let url = URL(string: "tel://\(location.phoneNumber)") else {
            alertItem = AlertContext.invalidPhoneNumber
            return
        }
        print(url)
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        } else {
            //show alert or something to show that you need a phone to do this
        }
    }
    
    
    func getCheckedInStatus(){
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {return}
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
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
            }catch {
                alertItem = AlertContext.unableToGetCheckedInStatus
            }
        }
    }
    
    
    func updateCheckInStatus(to checkInStatus: CheckInStatus){
        NotificationManager.shared.requestAuthorization()
        // Retrieve the DDGProfile
        guard let profileRecordID = CloudKitManager.shared.profileRecordID else {
            alertItem = AlertContext.unableToGetProfile
            return
        }
        
        showLoadingView()
        
        Task {
            do {
                let record = try await CloudKitManager.shared.fetchRecord(with: profileRecordID)
                switch checkInStatus {
                case .checkedIn:
                    record[DDGProfile.kIsCheckedIn] = CKRecord.Reference(recordID: location.id, action: .none)
                    record[DDGProfile.kIsCheckedInNilCheck] = 1
                case .checkedOut:
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kIsCheckedInNilCheck] = nil
                }
                let savedRecord = try await CloudKitManager.shared.save(record: record)
                HapticManager.playSuccess()
                let profile = DDGProfile(record: savedRecord)
                switch checkInStatus {
                case .checkedIn:
                    checkedInProfiles.append(profile)
                case .checkedOut:
                    checkedInProfiles.removeAll(where: {$0.id == profile.id})
                }
                //update our checkedInProfile array
                isCheckedIn.toggle()
                NotificationManager.shared.scheduleNotification(isCheckedIn: isCheckedIn, locationName: location.name)
                hideLoadingView()
                print("Checked in/out successfully")
            }catch {
                hideLoadingView()
                alertItem = AlertContext.unableToCheckInOrOut
            }
        }
    }
    
    
    func getCheckedInProfiles(){
        showLoadingView()
        Task {
            do {
                checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfiles(for: location.id)
                hideLoadingView()
            } catch {
                alertItem = AlertContext.unableToGetCheckedInProfiles
                hideLoadingView()
            }
        }
    }
    
    
    func show(_ profile: DDGProfile, in dynamicTypeSize: DynamicTypeSize){
        selectedProfile = profile
        if dynamicTypeSize >= .accessibility3 {
            isShowingProfileSheet = true
        } else {
            isShowingProfileModal = true
        }
    }
    
    private func showLoadingView(){ isLoading = true}
    private func hideLoadingView(){isLoading = false}
}
