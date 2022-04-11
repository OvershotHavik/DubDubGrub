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
    
    static let locationRestricted = AlertItem(title: Text("Locations Restricted"),
                                                message: Text("Your location is restricted. This may be due to parental controls."),
                                                dismissButton: .default(Text("OK")))
    
    static let locationDenied = AlertItem(title: Text("Locations Denied"),
                                                message: Text("Dub Dub Grub does not have permission to access your location.\nTo Change that, go to your phone's Settings > Dub Dub Grub > Location."),
                                                dismissButton: .default(Text("OK")))
    
    static let locationDisabled = AlertItem(title: Text("Locations service Disabled"),
                                                message: Text("Your phone's location services are disabled..\nTo Change that, go to your phone's settings > Privacy > Location Services."),
                                                dismissButton: .default(Text("OK")))
    
    // MARK: - Profile View Errors
    static let invalidProfile = AlertItem(title: Text("Invalid Profile"),
                                                message: Text("All fields are required as well as a profile photo. Your bio must be < 100 characters. \nPlease try again "),
                                                dismissButton: .default(Text("OK")))
}
