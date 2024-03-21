
import SwiftUI

@main
struct WeeklyThanksApp: App {
    
    @StateObject private var coordinator = NavigationCoordinator()

    
    var userViewModel = UserViewModel()
    var receiverViewModel = ReceiverViewModel()
    var thankYouCardViewModel = ThankYouCardViewModel()


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userViewModel)
                .environmentObject(receiverViewModel)
                .environmentObject(thankYouCardViewModel)
                .environmentObject(coordinator)



        }
    }
}
