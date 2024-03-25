//import UIKit
//import UserNotifications
//
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // Setup notification center delegate
//        UNUserNotificationCenter.current().delegate = self
//        
//        // Removed the immediate request for notification authorization
//        
//        return true
//    }
//    
//    // Implement UNUserNotificationCenterDelegate methods here as needed
//}
//
//extension AppDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let identifier = response.notification.request.identifier
//        
//        if identifier == "weeklyNotification" {
//            // This means the weekly notification was delivered; reset the card sent flag and manage daily notifications
//            UserDefaults.standard.set(false, forKey: "CardSentThisWeek")
//            NotificationManager.shared.manageDailyNotifications()
//        }
//        
//        completionHandler()
//    }
//}
//
//extension AppDelegate {
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        // Handle the notification while the app is in the foreground if needed
//        completionHandler([.banner, .sound])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        let identifier = response.notification.request.identifier
//        
//        if identifier == "weeklyNotification" {
//            // Reset the flag since the weekly notification just went out
//            UserDefaults.standard.set(false, forKey: "CardSentThisWeek")
//            // Start or restart daily notifications
//            NotificationManager.shared.manageDailyNotifications()
//        }
//
//        completionHandler()
//    }
//}


import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Setup notification center delegate
        UNUserNotificationCenter.current().delegate = self
        
        // Removed the immediate request for notification authorization
        
        return true
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification while the app is in the foreground if needed
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let identifier = response.notification.request.identifier
        
        if identifier == "weeklyNotification" {
            // Reset the flag since the weekly notification just went out
            UserDefaults.standard.set(false, forKey: "CardSentThisWeek")
            // Start or restart daily notifications
            NotificationManager.shared.manageDailyNotifications()
        }

        completionHandler()
    }
}
