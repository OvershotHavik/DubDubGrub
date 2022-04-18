//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var lm: LocationManager
    @StateObject private var vm = LocationListVM()
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State private var onAppearHasFired = false
    
    var body: some View {
        NavigationView{
            List{
                ForEach(lm.locations) { location in
                    NavigationLink(destination: vm.createLocationDetailView(for: location, in: dynamicTypeSize)) {
                        LocationListCell(location: location,
                                         profiles: vm.checkedInProfiles[location.id, default: []])
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text(vm.createVoiceOverSummary(for: location)))
                    }
                }
            }
            .onAppear{
                if !onAppearHasFired{
                    print("👀 on appeared called")
                    vm.getCheckedInProfilesDictionary()
                    onAppearHasFired = true
                }
            }
            .alert(item: $vm.alertItem, content: {$0.alert})
            .navigationTitle("Grub Spots")
            .listStyle(.plain)
        }
    }
}


struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
