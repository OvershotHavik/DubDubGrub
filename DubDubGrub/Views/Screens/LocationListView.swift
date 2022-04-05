//
//  LocationListView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationListView: View {
    var body: some View {
        NavigationView{
            List{
                ForEach(0..<10) { item in
                    NavigationLink(destination: LocationDetailView(title: "Title", address: "Testing address", description: "Test description ")) {
                        LocationListCell(title: "Location List View")
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
