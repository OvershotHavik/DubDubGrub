//
//  AppTabVM.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/13/22.
//

import CoreLocation

final class AppTabVM: NSObject, ObservableObject{
    @Published var isShowingOnboardView = false
    @Published var alertItem: AlertItem?
    
    var deviceLocationManager: CLLocationManager?
    
    let kHasSeenOnboardView = "hasSeenOnboardView"
    var hasSeenOnboardView: Bool {
        return UserDefaults.standard.bool(forKey: kHasSeenOnboardView) // will return false if not set
    }
    func runStartupChecks(){
        if !hasSeenOnboardView {
            isShowingOnboardView = true
            UserDefaults.standard.set(true, forKey: kHasSeenOnboardView)
        } else {
            checkIfLocationServicesIsEnabled()
        }
    }
    
    
    func checkIfLocationServicesIsEnabled(){
        if CLLocationManager.locationServicesEnabled(){
           deviceLocationManager = CLLocationManager()
            deviceLocationManager?.delegate = self
        } else {
            alertItem = AlertContext.locationDisabled
        }
    }
    
    
    private func checkLocationAuthorization(){
        guard let deviceLocationManager = deviceLocationManager else { return}
        
        switch deviceLocationManager.authorizationStatus{
        case .notDetermined:
            deviceLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            alertItem = AlertContext.locationRestricted
        case .denied:
            alertItem = AlertContext.locationDenied
        case .authorizedAlways,  .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
}


extension AppTabVM: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
