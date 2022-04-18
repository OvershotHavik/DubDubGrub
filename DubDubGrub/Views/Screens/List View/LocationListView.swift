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
    @Environment(\.sizeCategory) var sizeCategory
    
    var body: some View {
        NavigationView{
            List{
                ForEach(lm.locations) { location in
                    NavigationLink(destination: vm.createLocationDetailView(for: location, in: sizeCategory)) {
                        LocationListCell(location: location,
                                         profiles: vm.checkedInProfiles[location.id, default: []])
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(Text(vm.createVoiceOverSummary(for: location)))
                    }
                }
            }
            .onAppear{
                vm.getCheckedInProfilesDictionary()
            }
            .alert(item: $vm.alertItem, content: {$0.alert})
            .navigationTitle("Grub Spots")
        }
    }
}


struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}
