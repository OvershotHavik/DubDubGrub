//
//  LoadingView.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/11/22.
//

import SwiftUI

struct LoadingView: View {
    
    
    var body: some View {
        ZStack{
            Color(.systemBackground)
                .opacity(0.9)
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .brandPrimary))
                .scaleEffect(2)
                .offset(y: -40)
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
