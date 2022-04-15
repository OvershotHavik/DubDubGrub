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
                MapAnnotation(coordinate: location.location.coordinate,
                              anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
                    DDGAnnotation(location: location,
                                  number: vm.checkedInProfiles[location.id, default: 0])
                        .onTapGesture {
                            lm.selectedLocation = location
                            if let _ = lm.selectedLocation {
                                vm.isShowingDetailView = true
                            }
                            
                        }
                }
            }
                .accentColor(.grubRed)
                .ignoresSafeArea()
            
            VStack{
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)

                Spacer()
            }
        }
        .sheet(isPresented: $vm.isShowingDetailView, onDismiss: vm.getCheckedInCounts, content: {
            NavigationView{
                LocationDetailView(vm: LocationDetailVM(location: lm.selectedLocation!))
                    .toolbar {
                        Button("Dismiss", action: {vm.isShowingDetailView = false})
                            .foregroundColor(.brandPrimary)
                    }
            }
            
        })
        .onAppear{
            if lm.locations.isEmpty{
                vm.getLocations(for: lm)
            }
            vm.getCheckedInCounts()
        }
        .alert(item: $vm.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
    }
}
