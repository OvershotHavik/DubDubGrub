//
//  AlertItem.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/8/22.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    let title : Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext{
    // MARK: - Map View Errors
    static let unableToGetLocations = AlertItem(title: Text("Locations Error"),
                                                message: Text("Unable to retrieve locations at this time.\nPlease try again."),
                                                dismissButton: .default(Text("OK")))
}
