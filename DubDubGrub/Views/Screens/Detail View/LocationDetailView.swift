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
        VStack(spacing: 16){
            BannerImageView(image: vm.location.createBannerImage())
            
            HStack{
                AddressView(address: vm.location.address)
                Spacer()
            }
            DescriptionView(description: vm.location.description)
                        
            LocationButtonsHStack(location: vm.location, vm: vm)
            
            Text("Who's Here?")
                .bold()
                .font(.title2)
            
            ScrollView{
                LazyVGrid(columns: vm.column) {
                    ForEach(0..<10) { item in
                        FirstNameAvatarView(firstName: "Steve", image: PlaceholderImage.avatar)
                    }
                }
            }
            
            Spacer()
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
    var vm: LocationDetailVM
    
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
                
                Button {
                    
                } label: {
                    LocationActionButton(SFSymbols: "person.fill.xmark", color: Color(uiColor: UIColor.systemPink))
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
