//
//  AppTabView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct AppTabView: View {
    
    @StateObject private var vm = AppTabVM()
    
    var body: some View {
        TabView{
            LocationMapView()
                .tabItem {Label("Map", systemImage: "map")}
            LocationListView(vm: LocationListView.LocationListVM())
                .tabItem {Label("Locations", systemImage: "building")}
            NavigationView{
                ProfileView(vm: ProfileView.ProfileVM())
            }
            .tabItem {Label("Profile", systemImage: "person")}
        }
        .task{
            try? await CloudKitManager.shared.getUserRecord()
            vm.checkIfHasSeenOnboard()
            UIApplication.shared.applicationIconBadgeNumber = 0 // to remove the badge number on the app itself
        }
        .sheet(isPresented: $vm.isShowingOnboardView) {
            OnboardingView()
        }
    }
}


struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
