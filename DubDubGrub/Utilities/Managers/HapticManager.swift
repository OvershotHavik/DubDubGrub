//
//  HapticManager.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/18/22.
//

import UIKit

struct HapticManager{
    
    static func playSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}
