//
//  LocationMapView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//
import CoreLocationUI
import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @StateObject private var vm = LocationMapVM()
    @EnvironmentObject private var lm: LocationManager
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    
    var body: some View {
        ZStack(alignment: .top) {
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
                .ignoresSafeArea(edges: .top)
            
            Button {
                vm.setMapRegionToDefaultLocation()
            } label: {
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)
            }

        }
        .sheet(isPresented: $vm.isShowingDetailView, onDismiss: vm.getCheckedInCounts, content: {
            NavigationView{
                vm.createLocationDetailView(for: lm.selectedLocation!, in: dynamicTypeSize)
                    .toolbar {
                        Button("Dismiss", action: {vm.isShowingDetailView = false})
                    }
            }
        })
        .task{
            if lm.locations.isEmpty{
                vm.getLocations(for: lm)
            }
            vm.getCheckedInCounts()
        }
        .overlay(alignment: .bottomLeading, content: {
            LocationButton(.currentLocation) {
                vm.requestAllowOnceLocationPermission()
            }
            .foregroundColor(.white)
            .symbolVariant(.fill)
            .tint(.grubRed)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 0, leading: 15, bottom: 40, trailing: 0))
        })
        .alert(item: $vm.alertItem, content: {$0.alert})
    }
}
