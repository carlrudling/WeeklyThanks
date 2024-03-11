//
//  WeeklyThanksApp.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-02-23.
//

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
