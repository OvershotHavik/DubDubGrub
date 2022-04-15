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
            LocationListView()
                .tabItem {Label("Locations", systemImage: "building")}
            NavigationView{
                ProfileView()
            }
            .tabItem {Label("Profile", systemImage: "person")}
        }
        .onAppear{
            CloudKitManager.shared.getUserRecord()
            vm.runStartupChecks()
        }
        .sheet(isPresented: $vm.isShowingOnboardView, onDismiss: vm.checkIfLocationServicesIsEnabled) {
            OnboardingView(isShowingOnboardView: $vm.isShowingOnboardView)
        }
        .accentColor(.brandPrimary)
    }
}


struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
