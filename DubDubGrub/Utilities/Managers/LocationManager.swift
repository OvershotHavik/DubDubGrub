//
//  LocationManager.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/8/22.
//

import Foundation

final class LocationManager: ObservableObject{
    @Published var locations: [DDGLocation] = []
}
