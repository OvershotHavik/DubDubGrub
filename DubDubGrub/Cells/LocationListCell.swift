//
//  LocationListCell.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct LocationListCell: View {
    var title: String
    
    var body: some View {
            HStack{
             Image("default-square-asset")
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 80, height: 80)
                    
                VStack(alignment: .leading){
                    Text(title)
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
        LocationListCell(title: "Chipotle")
    }
}

struct AvatarView: View {
    var avatar: UIImage = UIImage(named: "default-avatar")!
    var size: CGFloat
    
    var body: some View {
        Image(uiImage: avatar)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: size, height: size)
    }
}
