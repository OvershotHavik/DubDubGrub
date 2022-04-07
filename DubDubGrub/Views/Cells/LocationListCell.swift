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
             Image("default-square-asset")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                    
                VStack(alignment: .leading){
                    Text(location.name)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .lineSpacing(1)
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

struct LocationListCell_Previews: PreviewProvider {
    static var previews: some View {
        LocationListCell(location: DDGLocation(record: MockData.location))
    }
}


