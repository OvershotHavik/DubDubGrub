//
//  LocationListCell.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationListCell: View {
    var location: DDGLocation
    
    var body: some View {
            HStack{
                Image(uiImage: location.createSquareImage())
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
                        AvatarView(size: 35)
                    }
                }
                .padding(.leading)
            }
        .padding(.vertical, 8)
    }
}



