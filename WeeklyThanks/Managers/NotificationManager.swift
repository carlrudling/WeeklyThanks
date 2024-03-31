
import Foundation
import SwiftUI
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager() // Singleton instance

    private init() {} // Private constructor to enforce singleton usage

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
                self.scheduleMidWeekReminder()
                self.scheduleEndOfWeekReminder()
            } else if let error = error {
                print("Notification permission denied because: \(error.localizedDescription).")
            }
        }
    }
    
    func scheduleMidWeekReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Midweek Check-In"
        content.body = "Some days have gone now of the week, any thank you cards you want to send?"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.weekday = 5 // Thursday (Note: Sunday = 1)
        dateComponents.hour = 10   // 10 AM, adjust as needed
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "midWeekReminder", content: content, trigger: trigger)
        
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling midweek test notification: \(error)")
        } else {
            print("Midweek test notification scheduled to repeat every 5 minutes.")
        }
    }
}
    func scheduleEndOfWeekReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Week's End Reminder"
        content.body = "The Week is coming to an end, last chance to send some thank you cards about the week."
        content.sound = UNNotificationSound.default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // Sunday
        dateComponents.hour = 10   // 10 AM, adjust as needed
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "endOfWeekReminder", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling end of week notification: \(error)")
            } else {
                print("End of week notification scheduled.")
            }
        }
    }

    func congratulateForReachingGoal() {
        let content = UNMutableNotificationContent()
        content.title = "Thanks for sharing!"
        content.body = "You've now reached your weekly goal."
        content.sound = UNNotificationSound.default
        content.badge = 1
        // Trigger immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "goalReached", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling goal reached notification: \(error)")
            } else {
                print("Goal reached notification scheduled.")
            }
        }
    }
    
}
