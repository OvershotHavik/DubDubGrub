//
//  LogoView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/5/22.
//

import SwiftUI

struct LogoView: View {
    var body: some View {
        Image("ddg-map-logo")
            .resizable()
            .scaledToFit()
            .frame(height: 70)
    }
}

struct LogoView_Previews: PreviewProvider {
    static var previews: some View {
        LogoView()
    }
}
