

import Foundation
import CoreData

class ReceiverViewModel: ObservableObject {
    private let dataManager = DataManager.shared
    @Published var receivers: [Receiver] = []
    @Published var name: String = ""
    @Published var userNickname: String = ""
    @Published var telephoneNumber:String = ""

    init() {
        fetchReceivers()
    }

    // Fetch all receivers from CoreData and update the published receivers array
    func fetchReceivers() {
        self.receivers = dataManager.fetchReceivers()
    }

    // Create a new receiver entity in CoreData
    func createReceiver(name: String, userNickname: String, telephoneNumber: String) {
        dataManager.createReceiver(name: name, userNickname: userNickname, telephoneNumber: telephoneNumber) { success in
            if success {
                // If creation is successful, re-fetch receivers to update UI
                self.fetchReceivers()
            }
        }
    }

    // Update an existing receiver entity in CoreData
    func updateReceiver(receiver: Receiver, name: String, userNickname: String, telephoneNumber: String) {
        // Update receiver's properties
        receiver.name = name
        receiver.userNickname = userNickname
        receiver.telephoneNumber = telephoneNumber
        
        // Save the changes
        dataManager.updateReceiver(receiver, withName: name, userNickname: userNickname, telephoneNumber: telephoneNumber)
        
        // Optionally re-fetch receivers if you need to update the UI
        fetchReceivers()
    }

    // Delete a receiver entity from CoreData
    func deleteReceiver(receiver: Receiver) {
        dataManager.deleteReceiver(receiver)
        // After deletion, re-fetch receivers to update UI
        fetchReceivers()
    }

}
