//
//  NotificationManager.swift
//  DubDubGrub
//
//  Created by Steve Plavetzky on 4/22/22.
//

import UserNotifications
import UIKit
import CoreLocation

final class NotificationManager{
    static let shared = NotificationManager()
    private init() {}
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
            } else {
                print("Successfully authorized push notifications!")
            }
        }
    }
    
    
    func scheduleNotification(isCheckedIn: Bool, locationName: String){
        if isCheckedIn{
            //set a reminder for the user to check out after 60 minutes or something
            let content = UNMutableNotificationContent()
            content.title = "Are you still at \(locationName)? "
            content.subtitle = "Don't forget to check out if you have left"
            content.sound = .default
            content.badge = 1
            
            //time
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false )
            
            //calendar
    //        var dateComponents = DateComponents()
    //        dateComponents.hour = 12
    //        dateComponents.minute = 17
    //        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            //location
            //May want to add in the location, if they leave the area
    //        let coordinates = CLLocationCoordinate2D(latitude: 37.331516,
    //                                                 longitude: -121.891054)
    //        let region = CLCircularRegion(center: coordinates,
    //                                      radius: 100,
    //                                      identifier: UUID().uuidString)
    //        region.notifyOnExit = true
    //        region.notifyOnEntry = false
    //        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        } else {
            cancelNotifications()
        }
    }
        
    
    func cancelNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
