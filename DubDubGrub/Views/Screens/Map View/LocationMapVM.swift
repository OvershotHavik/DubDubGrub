//
//  LocationMapVM.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/8/22.
//

import MapKit
import CloudKit

final class LocationMapVM: ObservableObject{
    
    @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
    @Published var isShowingDetailView = false
    @Published var alertItem: AlertItem?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516,
                                                                                  longitude: -121.891054),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                          longitudeDelta: 0.01))

    func getLocations(for locationManager: LocationManager){
        CloudKitManager.shared.getLocations { [self] result in
            DispatchQueue.main.async {
                switch result{
                case .success(let locations):
                    locationManager.locations = locations
                case .failure(_):
                    self.alertItem = AlertContext.unableToGetLocations
                }
            }
        }
    }
    
    
    func getCheckedInCounts(){
        CloudKitManager.shared.getCheckedInProfilesCount{ result in
            DispatchQueue.main.async {
                switch result{
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure(_):
                    //show alert
                    break
                }
            }
        }
    }
    
    
    func createVoiceOverSummary(for location: DDGLocation) -> String{
        let count = checkedInProfiles[location.id, default: 0]
        let personPlurality = count == 1 ? "person" : "people"
        
        return "Map Pin \(location.name) \(count) \(personPlurality) checked in."
    }
}
