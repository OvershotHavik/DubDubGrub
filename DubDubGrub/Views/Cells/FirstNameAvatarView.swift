//
//  AvatarCell.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct FirstNameAvatarView: View {
    
    var profile: DDGProfile
    
    var body: some View {
        VStack{
            AvatarView(image: profile.createAvatarImage(), size: 64)
            Text(profile.firstName)
                .fontWeight(.bold)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
        }
        .padding()
    }
}


struct FirstNameAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        FirstNameAvatarView(profile: DDGProfile(record: MockData.profile))
    }
}
