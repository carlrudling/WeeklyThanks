
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
        let messages = [
            "Reminder: It’s thank-you Thursday! Who are you thanking today?",
            "Touch hearts this week—send a thank-you card to show you care!",
            "Show your gratitude with a thank-you card today!",
            "Thank a friend, make a memory—have you sent your cards this week?",
            "Make a moment memorable—send a thank-you card today!",
            "Don't let the week slip away without sending a thank-you card!",
            "Spread some joy—whom will you surprise with a thank-you card today?",
            "Make it a habit—thank a different friend every week!",
            "Turn your thoughts into action—thank someone with a card today!",
            "A small gesture, a grand impact—send a thank-you card today!",
            "Capture the good vibes of the week—send out a thank-you card now!",
            "Gratitude is contagious—spread it with a thank-you card!",
            "Have a minute? Use it to make someone's day with a thank-you card!",
            "A thank-you card a day keeps the gloominess away!",
            "Just a moment to appreciate—whom will you thank today?",
            "Feeling grateful? Share the vibe with a quick thank-you card!",
            "Who brightened your day? Return the favor with a thank-you card!"
           ]
        
        content.body = messages.randomElement() ?? "Time to send a thank-you card!"  // Default message in case of nil
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
        let messages = [
                "Week's winding down—time to send those thank-you cards!",
                "Who made your week special? Send them a thank-you card!",
                "The week's flying by—send a thank-you card to make someone's day!",
                "Remember those who helped this week—send a quick thank-you card!",
                "Touch hearts this week—send a thank-you card to show you care!",
                "Show your gratitude with a thank-you card today!",
                "Thank a friend, make a memory—have you sent your cards this week?",
                "Make a moment memorable—send a thank-you card today!",
                "Don't let the week slip away without sending a thank-you card!",
                "Spread some joy—whom will you surprise with a thank-you card today?",
                "Make it a habit—thank a different friend every week!",
                "Turn your thoughts into action—thank someone with a card today!",
                "A small gesture, a grand impact—send a thank-you card today!",
                "Capture the good vibes of the week—send out a thank-you card now!",
                "Gratitude is contagious—spread it with a thank-you card!",
                "Have a minute? Use it to make someone's day with a thank-you card!",
                "A thank-you card a day keeps the gloominess away!",
                "Just a moment to appreciate—whom will you thank today?",
                "Feeling grateful? Share the vibe with a quick thank-you card!",
                "Who brightened your day? Return the favor with a thank-you card!"

               // Add all your messages here
           ]
        content.body = messages.randomElement() ?? "Time to send a thank-you card!"  // Default message in case of nil
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
