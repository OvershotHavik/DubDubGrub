//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationListView: View {
    @EnvironmentObject private var lm: LocationManager
    
    var body: some View {
        NavigationView{
            List{
                ForEach(lm.locations) { location in
                    NavigationLink(destination: LocationDetailView(location: location)) {
                        LocationListCell(location: location)
                    }
                }
            }
            .navigationTitle("Grub Spots")
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}