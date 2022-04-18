//
//  LocationListCell.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationListCell: View {
    
    var location: DDGLocation
    var profiles: [DDGProfile]
    
    var body: some View {
            HStack{
                Image(uiImage: location.squareImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                    
                VStack(alignment: .leading){
                    Text(location.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)
                    HStack{
                        if profiles.isEmpty{
                            Text("Nobody's Checked Nn")
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .padding(.top, 2)
                        } else {
                            HStack{
                                ForEach(profiles.indices, id: \.self) {index in
                                    if index <= 3{
                                        AvatarView(image: profiles[index].avatarImage, size: 35)
                                    } else if index == 4{
                                        AdditionalProfilesView(number: min(profiles.count - 4, 99))
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.leading)
            }
        .padding(.vertical, 8)
    }
}


fileprivate struct AdditionalProfilesView: View {
    var number: Int
    
    var body: some View{
        Text("+\(number)")
            .font(.system(size: 14, weight: .semibold))
            .frame(width: 35, height: 35)
            .foregroundColor(.white)
            .background(Color.brandPrimary)
            .clipShape(Circle())
    }
}

