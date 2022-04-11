//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    @StateObject private var vm = LocationMapVM()
    @EnvironmentObject private var lm: LocationManager
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $vm.region,
                showsUserLocation: true,
                annotationItems: lm.locations) { location in
                MapMarker(coordinate: location.location.coordinate, tint: .brandPrimary)
            }
                .accentColor(.grubRed)
                .ignoresSafeArea()
            
            VStack{
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)

                Spacer()
            }
        }
        .sheet(isPresented: $vm.isShowingOnboardView, onDismiss: vm.checkIfLocationServicesIsEnabled) {
            OnboardingView(isShowingOnboardView: $vm.isShowingOnboardView)
        }
        .onAppear{
            vm.runStartupChecks()
            if lm.locations.isEmpty{
                vm.getLocations(for: lm)
            }
        }
        .alert(item: $vm.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}
