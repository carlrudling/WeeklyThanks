import UIKit
import UserNotifications

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Set up the notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    private func requestNotificationAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission denied because: \(error.localizedDescription).")
            }
        }
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
            // Here, implement any specific logic you need when the user interacts with the weekly reminder notification
            break
        case "midWeekReminder":
            print("Handle mid-week reminder action.")
            // Similar handling for mid-week reminders
            break
        case "endOfWeekReminder":
            print("Handle end-of-week reminder action.")
            // And for the end-of-week reminder
            break
        // Add more cases as needed
        default:
            break
        }
        
        completionHandler()
    }
}
