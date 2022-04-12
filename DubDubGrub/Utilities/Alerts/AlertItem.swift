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
                                                message: Text("All fields are required as well as a profile photo. Your bio must be < 100 characters. \nPlease try again."),
                                                dismissButton: .default(Text("OK")))
    
    static let noUserRecord = AlertItem(title: Text("No User Record"),
                                                message: Text("You must log into iCloud on your phone in order to utilize Dub Dub Grub's Profile.\nPlease log in on your phone's settings screen."),
                                                dismissButton: .default(Text("OK")))
    
    static let createProfileSuccess = AlertItem(title: Text("Profile Created Successfully!"),
                                                message: Text("Your profile has successfully been created."),
                                                dismissButton: .default(Text("OK")))
    
    static let createProfileFailure = AlertItem(title: Text("Failed to Create Profile"),
                                                message: Text("We were unable to create your profile at this time.\nPlease try again later or contact customer support if this persists."),
                                                dismissButton: .default(Text("OK")))
    
    static let unableToGetProfile = AlertItem(title: Text("Unable to Retrieve Profile"),
                                                message: Text("We were unable to retrieve your profile at this time.\nPlease check your internet and please try again later or contact customer support if this persists."),
                                                dismissButton: .default(Text("OK")))
    
    static let updateProfileSuccess = AlertItem(title: Text("Profile Update Success!"),
                                                message: Text("Your Dub Dub Grub profile was updated successfully."),
                                                dismissButton: .default(Text("OK")))
    
    static let updateProfileFailure = AlertItem(title: Text("Profile Update Failed"),
                                                message: Text("We were unable to update your profile at this time.\nPlease try again later."),
                                                dismissButton: .default(Text("OK")))
    
    // MARK: - Location Detail view Errors
    static let invalidPhoneNumber = AlertItem(title: Text("Invalid Phone Number"),
                                                message: Text("The phone number for the location is invalid. Please look up the phone number from the website provided."),
                                                dismissButton: .default(Text("OK")))
}
