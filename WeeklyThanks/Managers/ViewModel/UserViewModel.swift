import Foundation
import UIKit
import CoreData

class UserViewModel: ObservableObject {
    private let dataManager = DataManager.shared
    @Published var currentUser: User?
    @Published var name: String = ""
    @Published var count: Int = 0
    @Published var sendCardGoal: Int = 0
    @Published var goalWeekStrike: Int = 0
    @Published var sentCardsThisWeek: Int = 0
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var userExists: Bool = false
    @Published var lastSentCard = Date()
    @Published var profileImage: UIImage?
    @Published var selfSentCardCount: Int = 0

    
    init() {
        fetchCurrentUser()
    }

    func checkUserExistence() {
            let users = DataManager.shared.fetchUsers()
            userExists = !users.isEmpty
        }
    
    var hasProfileImage: Bool {
          return profileImage != nil
      }
    
    func incrementSelfCardCount() {
          guard let user = currentUser else { return }

          // Increment the message count
          user.selfSentCardCount += 1
          self.selfSentCardCount += 1 // Update the published property as well
          
          // Save changes
          dataManager.saveContext()
      }
    
    func incrementMessageCount() {
          guard let user = currentUser else { return }

          // Increment the message count
          user.count += 1
          self.count += 1 // Update the published property as well
          
          // Save changes
          dataManager.saveContext()
      }
    
    func incrementSelfSentCardCount() {
          guard let user = currentUser else { return }

          // Increment the message count
          user.selfSentCardCount += 1
          self.selfSentCardCount += 1 // Update the published property as well
          
          // Save changes
          dataManager.saveContext()
      }
    
    
    func incrementWeeklySentCount() {
          guard let user = currentUser else { return }

          // Increment the message count
          user.sentCardsThisWeek += 1
          self.sentCardsThisWeek += 1 // Update the published property as well
          
          // Save changes
          dataManager.saveContext()
      }
    
    func updateLastSentCardDate(date: Date = Date()) {
        guard let user = currentUser else { return }
        user.lastSentCard = date
        dataManager.saveContext()
    }
    
    func checkAndResetWeeklySentCountIfNeeded() {
        guard let user = currentUser, let lastSentCardDate = user.lastSentCard else { return }

        let calendar = Calendar.current
        let currentWeek = calendar.component(.weekOfYear, from: Date())
        let lastSentCardWeek = calendar.component(.weekOfYear, from: lastSentCardDate)
        if currentWeek != lastSentCardWeek {
            resetWeeklySentCount()
        }
    }
    
    func resetWeeklySentCount() {
          guard let user = currentUser else { return }

          // Increment the message count
          user.sentCardsThisWeek = 0
          self.sentCardsThisWeek = 0// Update the published property as well
          
          // Save changes
          dataManager.saveContext()
      }
    
    func fetchCurrentUser() {
        let users = dataManager.fetchUsers()
        // Assuming you're interested in the first user for simplicity
        if let firstUser = users.first {
            currentUser = firstUser
            // Update the published properties
            self.name = firstUser.name ?? ""
            self.count = Int(firstUser.count) // Assuming count is stored as Int64 in Core Data
            self.email = firstUser.email ?? ""
            self.password = firstUser.password ?? ""
            self.sendCardGoal = Int(firstUser.sendCardGoal)
            self.goalWeekStrike = Int(firstUser.goalWeekStrike)
            self.sentCardsThisWeek = Int(firstUser.sentCardsThisWeek)
            self.lastSentCard = firstUser.lastSentCard ?? Date()
            self.selfSentCardCount = Int(firstUser.selfSentCardCount)

            // Updating the profile image if it exists in Core Data
            if let imageData = firstUser.profileImage as Data? {
                self.profileImage = UIImage(data: imageData)
            } else {
                self.profileImage = nil
            }
        } else {
            // Reset or handle the case where no user is found
            userExists = false
        }
    }

    
    func createUser(name: String, sendCardGoal: Int) {
        dataManager.createUser(name: name, email: self.email, password: self.password, count: 0, sendCardGoal: sendCardGoal, goalWeekStrike: 0, sentCardsThisWeek: 0, lastSentCard: Date()) { success in
            if success {
                DispatchQueue.main.async {
                    self.fetchCurrentUser() // Refresh the user info
                    self.userExists = true
                }
            }
        }
    }




    func saveProfileImage() {
        guard let user = currentUser, let imageData = profileImage?.jpegData(compressionQuality: 0.5) else { return }
        user.profileImage = imageData
        dataManager.saveContext()
    }


    func loadProfileImage() {
        guard let imageData = currentUser?.profileImage else { return }
        self.profileImage = UIImage(data: imageData)
    }



    // Updated UserViewModel function
    func updateUser(name: String? = nil, sendCardGoal: Int? = nil) {
        guard let currentUser = currentUser else { return }

        if let name = name {
            currentUser.name = name
            self.name = name // Update the ViewModel's published property
        }
        
        if let sendCardGoal = sendCardGoal {
            currentUser.sendCardGoal = Int64(sendCardGoal) // Assuming Core Data stores this as Int64
            self.sendCardGoal = sendCardGoal // Update the ViewModel's published property
        }

        // Save the changes
        dataManager.saveContext()
        // No need to call fetchCurrentUser() here unless you want to refresh other fields
    }



    
    // Implement saveContext() in DataManager or ensure it's called after updates
}
