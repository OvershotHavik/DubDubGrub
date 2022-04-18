//
//  AppTabVM.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/13/22.
//

import SwiftUI

extension AppTabView{
    
    final class AppTabVM: ObservableObject{
        
        @Published var isShowingOnboardView = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false {
            didSet{
                isShowingOnboardView = hasSeenOnboardView
            }
        }
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        
        func checkIfHasSeenOnboard(){
            if !hasSeenOnboardView {
                isShowingOnboardView = true
            }
        }
    }
}
