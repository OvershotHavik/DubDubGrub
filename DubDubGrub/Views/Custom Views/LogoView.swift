//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/5/22.
//

import SwiftUI

struct LogoView: View {
    
    var frameWidth: CGFloat
    
    var body: some View {
        Image(decorative: "ddg-map-logo") // the voice over would not read off this name when using decorative
            .resizable()
            .scaledToFit()
            .frame(width: frameWidth)
    }
}


struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView(frameWidth: 250)
    }
}
