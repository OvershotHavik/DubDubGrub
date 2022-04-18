//
//  LocationListVM.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/13/22.
//

import SwiftUI
import CloudKit

extension LocationListView{
    
    final class LocationListVM: ObservableObject{
        @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        @Published var alertItem: AlertItem?
        
        func getCheckedInProfilesDictionary(){
            CloudKitManager.shared.getCheckedInProfileDictionary { result in
                DispatchQueue.main.async {
                    switch result{
                    case .success(let checkedInProfiles):
                        self.checkedInProfiles = checkedInProfiles
                    case .failure(_):
                        self.alertItem = AlertContext.unableToGetAllCheckedInProfiles
                    }
                }
            }
        }
        
        
        func createVoiceOverSummary(for location: DDGLocation) -> String{
            let count = checkedInProfiles[location.id, default: []].count
            let personPlurality = count == 1 ? "person" : "people"
            
            return "\(location.name) \(count) \(personPlurality) checked in."
        }
        
        
        @ViewBuilder func createLocationDetailView(for location: DDGLocation, in sizeCategory: ContentSizeCategory) -> some View{
            if sizeCategory >= .accessibilityMedium {
                LocationDetailView(vm: LocationDetailVM(location: location))
                    .embedInScrollView()
            } else {
                LocationDetailView(vm: LocationDetailVM(location: location))
            }
        }
    }
}

