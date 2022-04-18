//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationDetailView: View {
    
    @ObservedObject var vm : LocationDetailVM
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    var body: some View {
        ZStack{
            
            VStack(spacing: 16){
                BannerImageView(image: vm.location.bannerImage)
                
                AddressHStack(address: vm.location.address)
                
                DescriptionView(description: vm.location.description)
                
                LocationButtonsHStack(location: vm.location, vm: vm)

                GridHeaderTextView(number: vm.checkedInProfiles.count)
                
                AvatarGridView(vm: vm)
            }
            .accessibilityHidden(vm.isShowingProfileModal)
            if vm.isShowingProfileModal{
                FullScreenBlackTransparencyView()
                ProfileModalView(profile: vm.selectedProfile ?? DDGProfile(record: MockData.profile),
                                 isShowingProfileModal: $vm.isShowingProfileModal)
            }
        }
        .task{
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
        .alert(item: $vm.alertItem, content: { $0.alert })
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
        .environment(\.dynamicTypeSize, .accessibility1)
        NavigationView{
            LocationDetailView(vm: LocationDetailVM(location: DDGLocation(record: MockData.chipotle)))
        }
        .preferredColorScheme(.dark)
        .environment(\.dynamicTypeSize, .accessibility5)
    }
}


fileprivate struct BannerImageView: View {
    
    var image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(height: 120)
            .accessibilityHidden(true)
    }
}


fileprivate struct AddressHStack: View {
    
    var address: String
    
    var body: some View {
        HStack{
            Label(address, systemImage: "mappin.and.ellipse")
                .font(.caption)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding(.horizontal)
    }
}


fileprivate struct LocationButtonsHStack: View {
    
    var location: DDGLocation
    @ObservedObject var vm: LocationDetailVM
    
    var body: some View {
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
                    } label: {
                        LocationActionButton(SFSymbols: vm.buttonImageTitle,
                                             color: vm.buttonCOlor)
                    }
                    .accessibilityLabel(Text(vm.buttonA11yLabel))
                    .disabled(vm.isLoading)
                }
            }
            .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
            .background(Color(.secondarySystemBackground))
            .clipShape(Capsule())
    }
}


fileprivate struct LocationActionButton: View {
    
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


fileprivate struct DescriptionView: View {
    
    var description: String
    
    var body: some View {
        Text(description)
            .minimumScaleFactor(0.75)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal)
    }
}


fileprivate struct GridHeaderTextView: View{
    var number: Int
    
    var body: some View{
        Text("Who's Here?")
            .bold()
            .font(.title2)
            .accessibilityAddTraits(.isHeader)
            .accessibilityLabel(Text("Who's Here? \(number) checked in"))
            .accessibilityHint(Text("Bottom section is scrollable."))
    }
}


fileprivate struct GridEmptyStateTextView: View{
    
    var body: some View{
        VStack{
            Text("Nobody's Here 😔")
                .bold()
                .font(.title2)
                .foregroundColor(.secondary)
                .padding(.top, 30)
            Spacer()
        }
    }
}


fileprivate struct FirstNameAvatarView: View {
    
    var profile: DDGProfile
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        VStack{
            AvatarView(image: profile.avatarImage,
                       size: dynamicTypeSize >= .accessibility3 ? 100 : 64)
            Text(profile.firstName)
                .fontWeight(.bold)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityAddTraits(.isButton)
        .accessibilityHint(Text("Shows \(profile.firstName)'s profile pop up."))
        .accessibilityLabel(Text("\(profile.firstName) \(profile.lastName)"))
        .padding()
    }
}


fileprivate struct FullScreenBlackTransparencyView: View{
    
    var body: some View{
        Color(.black)
            .ignoresSafeArea()
            .opacity(0.9)
            .transition(AnyTransition.opacity.animation(.easeOut(duration: 0.35)))
            .zIndex(1)
            .accessibilityHidden(true)
    }
}


fileprivate struct AvatarGridView: View{
    
    @ObservedObject var vm: LocationDetailVM
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View{
        ZStack{
            if vm.checkedInProfiles.isEmpty{
                GridEmptyStateTextView()
            } else {
                ScrollView{
                    LazyVGrid(columns: vm.determineColumns(for: dynamicTypeSize)) {
                        ForEach(vm.checkedInProfiles) { profile in
                            FirstNameAvatarView(profile: profile)
                                .onTapGesture {
                                    withAnimation(.easeIn){
                                        vm.show(profile, in: dynamicTypeSize)
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
    }
}
