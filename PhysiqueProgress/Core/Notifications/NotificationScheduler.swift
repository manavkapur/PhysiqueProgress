//
//  NotificationScheduler.swift
//  PhysiqueProgress
//
//  Created by Manav Kapur on 05/01/26.
//

import UserNotifications

final class NotificationScheduler {
    static func scheduleNotificationReminder(){
        
        let content = UNMutableNotificationContent()
        content.title = "Track your progress"
        content.body = "The today's physique photo to stau consistent"
        content.sound = .default
        
        var date = DateComponents()
        date.hour = 9
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        
        let request = UNNotificationRequest(identifier: "daily_progress_reminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current()
            .add(request)
    }
}
