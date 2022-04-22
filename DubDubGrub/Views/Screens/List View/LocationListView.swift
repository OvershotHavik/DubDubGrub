//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var lm: LocationManager
    @StateObject var vm : LocationListVM
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var onAppearHasFired = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(vm.searchResults) {location in
                    NavigationLink(destination: vm.createLocationDetailView(for: location, in: dynamicTypeSize)) {
                        LocationListCell(location: location,
                                         profiles: vm.checkedInProfiles[location.id, default: []])
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text(vm.createVoiceOverSummary(for: location)))
                    }
                }
            }
            .task{
                if !onAppearHasFired{
                    print("👀 on appeared called")
                    await vm.getCheckedInProfilesDictionary()
                    onAppearHasFired = true
                }
                vm.originalLocations = lm.locations
            }
            .onDisappear{
                onAppearHasFired = false
            }
            .refreshable {
                await vm.getCheckedInProfilesDictionary()
            }
            .searchable(text: $vm.searchText)
            .alert(item: $vm.alertItem, content: {$0.alert})
            .navigationTitle("Grub Spots")
            .listStyle(.plain)
        }
    }
}
