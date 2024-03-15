
import SwiftUI

@main
struct WeeklyThanksApp: App {
    
    var userViewModel = UserViewModel()
    var receiverViewModel = ReceiverViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(receiverViewModel)

        }
    }
}
