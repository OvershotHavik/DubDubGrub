//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationDetailView: View {
    
    @ObservedObject var vm : LocationDetailVM
    @Environment(\.sizeCategory) var sizeCategory

    var body: some View {
        ZStack{
            
            VStack(spacing: 16){
                BannerImageView(image: vm.location.bannerImage)
                
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
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityLabel(Text("Who's Here? \(vm.checkedInProfiles.count) checked in"))
                    .accessibilityHint(Text("Bottom section is scrollable."))
                
                ZStack{
                    if vm.checkedInProfiles.isEmpty{
                        Text("Nobody's Here 😔")
                            .bold()
                            .font(.title2)
                            .foregroundColor(.secondary)
                            .padding(.top, 30)
                    } else {
                        ScrollView{
                            LazyVGrid(columns: vm.determineColumns(for: sizeCategory)) {
                                ForEach(vm.checkedInProfiles) { profile in
                                    FirstNameAvatarView(profile: profile)
                                        .accessibilityElement(children: .ignore)
                                        .accessibilityAddTraits(.isButton)
                                        .accessibilityHint(Text("Shows \(profile.firstName)'s profile pop up."))
                                        .accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
                                        .onTapGesture {
                                            withAnimation(.easeIn){
                                                vm.show(profile: profile, in: sizeCategory)
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
            .accessibilityHidden(vm.isShowingProfileModal)
            if vm.isShowingProfileModal{
                Color(.black)
                    .ignoresSafeArea()
                    .opacity(0.9)
                    .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
                    .zIndex(1)
                    .accessibilityHidden(true)
                ProfileModalView(profile: vm.selectedProfile ?? DDGProfile(record: MockData.profile),
                                 isShowingProfileModal: $vm.isShowingProfileModal)
//                .accessibilityAddTraits(.isModal)
                .transition(.opacity.combined(with: .slide))
                .animation(.easeOut)
                .zIndex(2)
            }
        }
        .onAppear{
            vm.getCheckedInProfiles()
            vm.getCheckedInStatus()
        }
        .sheet(isPresented: $vm.isShowingProfileSheet, content: {
            NavigationView{
                ProfileSheetView(profile: vm.selectedProfile!)
            }
            .toolbar {
                Button("Dismiss", action: {vm.isShowingProfileSheet = false})
                    .foregroundColor(.brandPrimary)
            }
            
        })
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


struct LocationDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            LocationDetailView(vm: LocationDetailVM(location: DDGLocation(record: MockData.chipotle)))
        }
        .environment(\.sizeCategory, .extraExtraExtraLarge)
        NavigationView{
            LocationDetailView(vm: LocationDetailVM(location: DDGLocation(record: MockData.chipotle)))
        }
        .preferredColorScheme(.dark)
        .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
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
                .accessibilityLabel(Text("Get directions."))

                
                Link(destination: URL(string: location.websiteURL)!) {
                    LocationActionButton(SFSymbols: "network", color: Color.brandPrimary)
                }
                .accessibilityRemoveTraits(.isButton)
                .accessibilityLabel(Text("Go to website.."))

                
                Button {
                    vm.callLocation()
                } label: {
                    LocationActionButton(SFSymbols: "phone.fill", color: Color.brandPrimary)
                }
                .accessibilityLabel(Text("Call location."))

                
                if CloudKitManager.shared.profileRecordID != nil{
                    Button {
                        vm.updateCheckInStatus(to: vm.isCheckedIn ? .checkedOut : .checkedIn)
                        playHaptic()
                    } label: {
                        LocationActionButton(SFSymbols: vm.isCheckedIn ? "person.fill.xmark" : "person.fill.checkmark",
                                             color: vm.isCheckedIn ? .grubRed : .brandPrimary)
                        .accessibilityLabel(Text(vm.isCheckedIn ? "Check out of location." : "Check into location."))
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
            .accessibilityHidden(true)
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
            .minimumScaleFactor(0.75)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
    }
}
