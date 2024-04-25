import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set up the notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Initialize notification setup
        refreshNotifications()
        
        return true
    }

    func refreshNotifications() {
        // Remove old notifications
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["midWeekReminder", "endOfWeekReminder"])

        // Re-schedule notifications
        NotificationManager.shared.scheduleMidWeekReminder()
        NotificationManager.shared.scheduleEndOfWeekReminder()
    }

    // MARK: UNUserNotificationCenterDelegate Methods

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification while the app is in the foreground
        completionHandler([.alert, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the user's interaction with the notification (when the app is in the background or closed)
        let identifier = response.notification.request.identifier
        
        switch identifier {
        case "weeklyReminder":
            print("Handle weekly reminder action.")
            break
        case "midWeekReminder":
            print("Handle mid-week reminder action.")
            break
        case "endOfWeekReminder":
            print("Handle end-of-week reminder action.")
            break
        default:
            break
        }
        
        completionHandler()
    }
}
