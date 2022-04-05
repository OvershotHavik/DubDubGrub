//
//  AvatarCell.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/4/22.
//

import SwiftUI

struct FirstNameAvatarView: View {
    var firstName: String
    var avatar: UIImage = UIImage(named: "default-avatar")!
    
    var body: some View {
        VStack{
            AvatarView(size: 64)
            Text(firstName)
                .fontWeight(.bold)
                .minimumScaleFactor(0.75)
                .lineLimit(1)
        }
        .padding()
    }
}

struct FirstNameAvatarView_Previews: PreviewProvider {
    static var previews: some View {
        FirstNameAvatarView(firstName: "Steve")
    }
}
