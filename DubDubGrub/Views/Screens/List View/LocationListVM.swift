//
//  LocationListVM.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/13/22.
//

import SwiftUI
import CloudKit

extension LocationListView{
    
    @MainActor final class LocationListVM: ObservableObject{
        @Published var checkedInProfiles: [CKRecord.ID: [DDGProfile]] = [:]
        @Published var alertItem: AlertItem?
        
        func getCheckedInProfilesDictionary() async{
            do {
                print("Called")
                checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfileDictionary()
            }catch {
                alertItem = AlertContext.unableToGetAllCheckedInProfiles
            }
        }
        
        
        func createVoiceOverSummary(for location: DDGLocation) -> String{
            let count = checkedInProfiles[location.id, default: []].count
            let personPlurality = count == 1 ? "person" : "people"
            
            return "\(location.name) \(count) \(personPlurality) checked in."
        }
        
        
        @ViewBuilder func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View{
            if dynamicTypeSize >= .accessibility3 {
                LocationDetailView(vm: LocationDetailVM(location: location))
                    .embedInScrollView()
            } else {
                LocationDetailView(vm: LocationDetailVM(location: location))
            }
        }
    }
}

