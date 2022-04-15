//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationDetailView: View {
    
    @ObservedObject var vm : LocationDetailVM

    var body: some View {
        ZStack{
            
            VStack(spacing: 16){
                BannerImageView(image: vm.location.createBannerImage())
                
                HStack{
                    AddressView(address: vm.location.address)
                    Spacer()
                }
                .padding(.horizontal)
                DescriptionView(description: vm.location.description)
                    .padding(.horizontal)
                            
                LocationButtonsHStack(location: vm.location, vm: vm)
                    .padding(.horizontal)
                
                Text("Who's Here?")
                    .bold()
                    .font(.title2)
                ZStack{
                    if vm.checkedInProfiles.isEmpty{
                        Text("Nobody's Here 😔")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.top, 30)
                    } else {
                        ScrollView{
                            LazyVGrid(columns: vm.column) {
                                ForEach(vm.checkedInProfiles) { profile in
                                    FirstNameAvatarView(profile: profile)
                                        .onTapGesture {
                                            withAnimation(.easeIn){
                                                vm.isShowingProfileModal = true
                                            }
                                        }
                                }
                            }
                        }
                    }
                    if vm.isLoading{
                        LoadingView()
                    }
                }
                Spacer()
            }
            if vm.isShowingProfileModal{
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .opacity(0.9)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)
                ProfileModalView(profile: DDGProfile(record: MockData.profile),
                                 isShowingProfileModal: $vm.isShowingProfileModal)
                .transition(.opacity.combined(with: .slide))
                .animation(.easeOut)
                .zIndex(2)
            }
        }
        .onAppear{
            vm.getCheckedInProfiles()
            vm.getCheckedInStatus()
        }
        .alert(item: $vm.alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: alertItem.dismissButton)
        })
        .padding(.horizontal)
        .navigationTitle(vm.location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct LocationButtonsHStack: View {
    
    var location: DDGLocation
    @ObservedObject var vm: LocationDetailVM
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(height: 80)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
            HStack(spacing: 20){
                Button {
                    vm.getDirectionsToLocation()
                } label: {
                    LocationActionButton(SFSymbols: "location.fill", color: Color.brandPrimary)
                }

                Link(destination: URL(string: location.websiteURL)!) {
                    LocationActionButton(SFSymbols: "network", color: Color.brandPrimary)
                }

                Button {
                    vm.callLocation()
                } label: {
                    LocationActionButton(SFSymbols: "phone.fill", color: Color.brandPrimary)
                }

                if CloudKitManager.shared.profileRecordID != nil{
                    Button {
                        vm.updateCheckInStatus(to: vm.isCheckedIn ? .checkedOut : .checkedIn)
                    } label: {
                        LocationActionButton(SFSymbols: vm.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark",
                                             color: vm.isCheckedIn ? .grubRed : .brandPrimary)
                    }
                }
            }
        }
    }
}


struct LocationActionButton: View {
    
    var SFSymbols: String
    var color: Color
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            Image(systemName: SFSymbols)
                .resizable()
                .scaledToFit()
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
        }
    }
}


struct BannerImageView: View {
    
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
    }
}


struct AddressView: View {
    
    var address: String
    
    var body: some View {
        Label(address, systemImage: "mappin.and.ellipse")
            .font(.caption)
            .foregroundColor(.secondary)
    }
}


struct DescriptionView: View {
    
    var description: String
    
    var body: some View {
        Text(description)
            .lineLimit(3)
            .minimumScaleFactor(0.75)
            .multilineTextAlignment(.leading)
            .frame(height: 70)
    }
}
