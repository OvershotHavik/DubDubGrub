//
//  DDBButton.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/5/22.
//

import SwiftUI

struct DDGButton: View {
    
    var title: String
    var color: Color = .brandPrimary
    
    var body: some View {
        Text(title)
            .bold()
            .foregroundColor(.white)
            .frame(width: 280, height: 44)
            .background(color)
            .cornerRadius(8)
    }
}


struct DDBButton_Previews: PreviewProvider {
    static var previews: some View {
        DDGButton(title: "Testing Button")
    }
}
