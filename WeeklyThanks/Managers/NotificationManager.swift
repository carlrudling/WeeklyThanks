
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
//                self.scheduleWeeklyNotificationIfNeeded()
                self.scheduleWeeklyNotification()
                self.manageDailyNotifications()
            } else if let error = error {
                print("Notification permission denied because: \(error.localizedDescription).")
            }
        }
    }
    
//    func scheduleWeeklyNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Weekly Reminder"
//        content.body = "It's time to reflect over the week and send some thank you cards!"
//        content.sound = UNNotificationSound.default
//        content.badge = 1
//        
//        var dateComponents = DateComponents()
//        dateComponents.weekday = 1  // Sunday is typically represented as 1
//        dateComponents.hour = 10    // For example, 10 AM
//        
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        
//        let request = UNNotificationRequest(identifier: "weeklyNotification", content: content, trigger: trigger)
//        
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling weekly notification: \(error)")
//            }
//        }
//    }
    
    func scheduleWeeklyNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Weekly Reminder (Test)"
        content.body = "It's time to reflect over the week and send some thank you cards! (Test)"
        content.sound = UNNotificationSound.default
        content.badge = 1

        // Test trigger - triggers every 5 minutes
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6 * 60, repeats: true)

        let request = UNNotificationRequest(identifier: "weeklyNotificationTest", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling weekly (test) notification: \(error)")
            } else {
                print("Weekly (test) notification scheduled to repeat every 5 minutes.")
            }
        }
    }



    func resetWeeklyNotification() {
        // Cancel any existing weekly notification
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weeklyNotification"])
        
        // Re-schedule the weekly notification
        scheduleWeeklyNotification()
    }

    
//    func manageDailyNotifications() {
//        let cardSentThisWeek = UserDefaults.standard.bool(forKey: "CardSentThisWeek")
//
//        if !cardSentThisWeek {
//            // Schedule or reschedule the daily notification
//            scheduleDailyNotification()
//        }
//    }

//    func scheduleDailyNotification() {
//        let content = UNMutableNotificationContent()
//        content.title = "Reminder"
//        content.body = "Don't forget to send your weekly thank you cards!"
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 24 * 60 * 60, repeats: true) // Repeat daily
//
//        let request = UNNotificationRequest(identifier: "dailyNotification", content: content, trigger: trigger)
//
//        UNUserNotificationCenter.current().add(request) { error in
//            if let error = error {
//                print("Error scheduling daily notification: \(error)")
//            }
//        }
//    }
    
    func scheduleDailyNotificationEveryTwoMinutes() {
        let content = UNMutableNotificationContent()
        content.title = "Daily Reminder (Every 2 Minutes)"
        content.body = "Don't forget to send your weekly thank you card! (Repeating every 2 minutes for testing)"
        content.sound = UNNotificationSound.default
        content.badge = 1

        // Trigger - triggers every 2 minutes (120 seconds), repeats
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 120, repeats: true)

        let request = UNNotificationRequest(identifier: "dailyNotificationEveryTwoMinutes", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling daily notification (every 2 minutes): \(error)")
            } else {
                print("Daily notification scheduled to repeat every 2 minutes.")
            }
        }
    }

    func manageDailyNotifications() {
        let cardSentThisWeek = UserDefaults.standard.bool(forKey: "CardSentThisWeek")
        if !cardSentThisWeek {
            scheduleDailyNotificationEveryTwoMinutes() // Or however frequently you want it for testing
        } else {
            // Optionally, remove daily notifications here if you want them to stop immediately after a card is sent
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotificationEveryTwoMinutes"])
        }
    }

    func cardSent() {
        UserDefaults.standard.set(true, forKey: "CardSentThisWeek")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotificationEveryTwoMinutes"])
        // No need to manually start daily notifications here; they will restart when the next weekly notification is received and managed by the AppDelegate
    }

//    func cardSent() {
//        UserDefaults.standard.set(true, forKey: "CardSentThisWeek")
//        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["dailyNotification"])
//    }
    
    func scheduleWeeklyNotificationIfNeeded() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let isWeeklyNotificationScheduled = requests.contains { $0.identifier == "weeklyNotification" }
            
            if !isWeeklyNotificationScheduled {
                self.scheduleWeeklyNotification()
            }
        }
    }

    
//    func setupNotifications() {
//        requestAuthorization()
//        scheduleWeeklyNotificationIfNeeded()
//        manageDailyNotifications() // This will check if daily notifications need to be scheduled based on the cardSentThisWeek flag
//    }

    
    // Add other methods here (scheduleWeeklyNotification, manageDailyNotifications, cardSent, etc.)
}
