//
//  View+Ext.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/5/22.
//

import SwiftUI


extension View{
    func profileNameStyle() -> some View{
        self.modifier(ProfileNameText())
    }
    
    
}
