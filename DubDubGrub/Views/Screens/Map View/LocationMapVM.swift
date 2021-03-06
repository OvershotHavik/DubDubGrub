//
//  LocationMapVM.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/8/22.
//

import MapKit
import CloudKit
import SwiftUI

extension LocationMapView{
    
    @MainActor final class LocationMapVM: NSObject, ObservableObject, CLLocationManagerDelegate{
        
        @Published var checkedInProfiles: [CKRecord.ID: Int] = [:]
        @Published var isShowingDetailView = false
        @Published var alertItem: AlertItem?
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516,
                                                                                      longitude: -121.891054),
                                                       span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                              longitudeDelta: 0.01))

        let deviceLocationManager = CLLocationManager()
        override init(){
            super.init()
            deviceLocationManager.delegate = self
        }
        
        
        func requestAllowOnceLocationPermission(){
            deviceLocationManager.requestLocation()
        }
        
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else {
                //handle error
                return
            }
            withAnimation {
                    region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                                                           longitudeDelta: 0.01))
            }
        }
        
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Did fail with Error")
        }
        
        
        func getLocations(for locationManager: LocationManager){
            Task {
                do {
                    locationManager.locations = try await CloudKitManager.shared.getLocations()
                } catch {
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
        
        
        func getCheckedInCounts(){
            Task {
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
                }catch {
                    alertItem = AlertContext.checkedInCount
                }
            }
        }
        
        
         @ViewBuilder func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View{
            if dynamicTypeSize >= .accessibility3 {
                LocationDetailView(vm: LocationDetailVM(location: location))
                    .embedInScrollView()
            } else {
                LocationDetailView(vm: LocationDetailVM(location: location))
            }
        }
        
        
        func setMapRegionToDefaultLocation(){
            withAnimation {
                    region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.330642,
                                                                               longitude: -121.888681),
                                                span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                                       longitudeDelta: 0.01))
            }
        }
    }
}

