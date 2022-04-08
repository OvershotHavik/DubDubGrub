//
//  LocationDetailView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationDetailView: View {
    var location: DDGLocation
    let column = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 16){
            BannerImageView(image: location.createBannerImage())
            
            HStack{
                AddressView(address: location.address)
                Spacer()
            }
            DescriptionView(description: location.description)
                        
            LocationButtonsHStack(location: location)
            
            Text("Who's Here?")
                .bold()
                .font(.title2)
            
            ScrollView{
                LazyVGrid(columns: column) {
                    ForEach(0..<10) { item in
                        FirstNameAvatarView(firstName: "Steve")
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)

    }
}


struct LocationButtonsHStack: View {
    var location: DDGLocation
    var body: some View {
        ZStack{
            Capsule()
                .frame(height: 80)
                .foregroundColor(Color(uiColor: .secondarySystemBackground))
            HStack(spacing: 20){
                Button {
                    
                } label: {
                    LocationActionButton(sfSymbole: "location.fill", color: Color.brandPrimary)
                }
                
                
                Link(destination: URL(string: location.websiteURL)!) {
                    LocationActionButton(sfSymbole: "network", color: Color.brandPrimary)
                }
                
                Button {
                    
                } label: {
                    LocationActionButton(sfSymbole: "phone.fill", color: Color.brandPrimary)
                }
                
                Button {
                    
                } label: {
                    LocationActionButton(sfSymbole: "person.fill.xmark", color: Color(uiColor: UIColor.systemPink))
                }
            }
        }
    }
}


struct LocationActionButton: View {
    var sfSymbole: String
    var color: Color
    
    
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(color)
                .frame(width: 60, height: 60)
            Image(systemName: sfSymbole)
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
