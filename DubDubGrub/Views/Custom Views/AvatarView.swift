//
//  AvatarView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/5/22.
//

import SwiftUI

struct AvatarView: View {
    
    var image: UIImage
    var size: CGFloat
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .frame(width: size, height: size)
    }
}


struct AvatarView_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(image: PlaceholderImage.avatar, size: 90)
    }
}
