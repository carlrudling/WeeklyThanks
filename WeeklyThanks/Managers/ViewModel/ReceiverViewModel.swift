

import Foundation
import CoreData

class ReceiverViewModel: ObservableObject {
    private let dataManager = DataManager.shared
    @Published var receivers: [Receiver] = []
    @Published var name: String = ""
    @Published var telephoneNumber: String = ""
    @Published var currentReceiver: Receiver?
    @Published var currentReceiverId: UUID? // Holds the ID of the current receiver

    init() {
        fetchReceivers()
    }

    func fetchReceivers(completion: (() -> Void)? = nil) {
        self.receivers = dataManager.fetchReceivers()
        completion?()
    }


    // Create a new receiver entity in CoreData
//    func createReceiver(name: String, telephoneNumber: String) {
//        dataManager.createReceiver(name: name, telephoneNumber: telephoneNumber) { [weak self] success, newReceiverId in
//            if success, let newId = newReceiverId {
//                // If creation is successful, re-fetch receivers to update UI and set the current receiver
//                self?.fetchReceivers {
//                    self?.setCurrentReceiver(by: newId)
//                }
//            } else {
//                print("Failed to create new receiver")
//            }
//        }
//    }
    
    func createReceiver(name: String, telephoneNumber: String) {
        // Check if a receiver with the given telephone number already exists
        if let existingReceiver = receivers.first(where: { $0.telephoneNumber == telephoneNumber }) {
            // Receiver exists, set as current receiver and do not create a new one
            print("Receiver with telephone number \(telephoneNumber) already exists.")
            setCurrentReceiver(by: existingReceiver.id ?? UUID())
        } else {
            // Receiver does not exist, proceed with creation
            dataManager.createReceiver(name: name, telephoneNumber: telephoneNumber) { [weak self] success, newReceiverId in
                if success, let newId = newReceiverId {
                    // If creation is successful, re-fetch receivers to update UI and set the current receiver
                    self?.fetchReceivers {
                        self?.setCurrentReceiver(by: newId)
                    }
                } else {
                    print("Failed to create new receiver")
                }
            }
        }
    }


    
    func setCurrentReceiver(by id: UUID) {
        self.currentReceiverId = id
        guard let receiver = receivers.first(where: { $0.id == id }) else {
            print("Receiver with ID \(id) not found")
            return
        }
        self.currentReceiver = receiver
        self.name = receiver.name ?? ""
        self.telephoneNumber = receiver.telephoneNumber ?? ""
    }

    func updateCurrentReceiver(name: String, telephoneNumber: String) {
        guard let id = currentReceiverId,
              let updatingReceiver = receivers.first(where: { $0.id == id }) else {
            print("Current receiver is not set or not found")
            return
        }
        
        updatingReceiver.name = name
        updatingReceiver.telephoneNumber = telephoneNumber
        dataManager.updateReceiver(updatingReceiver, withName: name, telephoneNumber: telephoneNumber)
        
        fetchReceivers() // Refresh data
    }

    // Delete a receiver entity from CoreData
    func deleteReceiver(receiver: Receiver) {
        dataManager.deleteReceiver(receiver)
        // After deletion, re-fetch receivers to update UI
        fetchReceivers()
    }
    
    func cleanValues() {
        name = ""
        telephoneNumber = ""
    }}
