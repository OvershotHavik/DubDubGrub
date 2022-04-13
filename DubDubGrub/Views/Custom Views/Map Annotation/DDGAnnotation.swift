//
//  DDGAnnotation.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/13/22.
//

import SwiftUI

struct DDGAnnotation: View {
    var location: DDGLocation
    
    var body: some View {
        VStack{
            ZStack{
                MapBalloon()
                    .frame(width: 100, height: 70)
                    .foregroundColor(.brandPrimary)
                Image(uiImage: location.createSquareImage())
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .offset(y: -11)
                Text("99")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 26, height: 18)
                    .background(Color.grubRed)
                    .clipShape(Capsule())
                    .offset(x: 20, y: -28)
            }

            Text(location.name)
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

struct DDGAnnotation_Previews: PreviewProvider {
    static var previews: some View {
        DDGAnnotation(location: DDGLocation(record: MockData.location))
    }
}
