import Foundation
import CoreData

class UserViewModel: ObservableObject {
    private let dataManager = DataManager.shared
    @Published var currentUser: User?
    @Published var name: String = ""
    @Published var count: Int = 0
    @Published var email: String = ""
    @Published var password: String = ""

    init() {
        fetchCurrentUser()
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
        }
    }
    
    func createUser(name: String) {
        dataManager.createUser(name: name, email: self.email, password: self.password, count: 0) { success in
            if success {
                DispatchQueue.main.async {
                    // Update ViewModel state as needed
                    self.fetchCurrentUser() // This will fetch the new user and update the ViewModel
                }
            }
        }
    }



    // In UserViewModel
    func updateUser(name: String? = nil, email: String? = nil, password: String? = nil, incrementCount: Bool = false) {
        guard let currentUser = currentUser else { return }
        if let name = name { currentUser.name = name }
        if let email = email { currentUser.email = email }
        if let password = password { currentUser.password = password }
        if incrementCount { currentUser.count += 1 } // Increment count if specified

        // Save the changes
        dataManager.saveContext()
        fetchCurrentUser() // Optionally refresh the user data in the ViewModel
    }


    
    // Implement saveContext() in DataManager or ensure it's called after updates
}
