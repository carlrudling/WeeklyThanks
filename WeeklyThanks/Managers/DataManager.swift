
import Foundation
import CoreData
import SwiftUI

class DataManager {
    static let shared = DataManager()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "AppDataModel")
        let description = container.persistentStoreDescriptions.first
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Core Data store failed to load with error: \(error.localizedDescription)")
            }
        }
    }

    
    // MARK: ThankYouCard CRUD Operations

    
    func createThankYouCard(message: String, writeDate: Date, user: User, receiver: Receiver, count: Int64, theme: String, completion: @escaping (Bool) -> Void) {
        let context = container.viewContext
        let newCard = ThankYouCard(context: context)
        newCard.id = UUID()
        newCard.message = message
        newCard.writeDate = writeDate
        newCard.user = user
        newCard.receiver = receiver
        newCard.count = count // Set the count attribute
        newCard.theme = theme

        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to save the card: \(error.localizedDescription)")
            completion(false)
        }
    }


    
    func fetchThankYouCards() -> [ThankYouCard] {
        let request: NSFetchRequest<ThankYouCard> = ThankYouCard.fetchRequest()
        // If sorting by date, ensure your cards have a 'writeDate' attribute.
        let sortDescriptor = NSSortDescriptor(key: "writeDate", ascending: false) // Sort in descending order so latest cards appear first
        request.sortDescriptors = [sortDescriptor]

        let context = container.viewContext
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to fetch cards: \(error.localizedDescription)")
            return []
        }
    }


    
    func updateCard(card: ThankYouCard, withMessage message: String) {
        let context = container.viewContext
        card.message = message

        do {
            try context.save()
        } catch {
            print("Failed to update the card: \(error.localizedDescription)")
        }
    }

    
    func deleteCard(card: ThankYouCard) {
        let context = container.viewContext
        context.delete(card)

        do {
            try context.save()
        } catch {
            print("Failed to delete the card: \(error.localizedDescription)")
        }
    }
    
    
    // MARK: User CRUD Operations

    // In DataManager
    func createUser(name: String, email: String, password: String, count: Int, sendCardGoal: Int, goalWeekStrike: Int, sentCardsThisWeek: Int, lastSentCard: Date, completion: @escaping (Bool) -> Void) {
        // Your implementation to create a user and handle the count
        // For simplicity, we'll assume your CoreData User entity has a `count` attribute to store this value
        let newUser = User(context: container.viewContext)
        newUser.id = UUID()
        newUser.name = name
        newUser.email = email
        newUser.password = password
        newUser.count = Int64(count) // Assuming `count` is stored as Int64 in CoreData
        newUser.sendCardGoal = Int64(sendCardGoal)
        newUser.goalWeekStrike = Int64(goalWeekStrike)
        newUser.sentCardsThisWeek = Int64(sentCardsThisWeek)
        newUser.lastSentCard = Date()
        
        do {
            try container.viewContext.save()
            completion(true)
        } catch {
            print("Error saving User: \(error)")
            completion(false)
        }
    }


    func fetchUsers() -> [User] {
        let request: NSFetchRequest<User> = User.fetchRequest()
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching Users: \(error)")
            return []
        }
    }

    func updateUser(_ user: User, withName name: String, email: String, password: String) {
        user.name = name
        user.email = email
        user.password = password
        
        do {
            try container.viewContext.save()
        } catch {
            print("Error updating User: \(error)")
        }
    }

    func deleteUser(_ user: User) {
        container.viewContext.delete(user)
        
        do {
            try container.viewContext.save()
        } catch {
            print("Error deleting User: \(error)")
        }
    }
    
    // In DataManager
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Handle the error appropriately
                print("Error saving context: \(error.localizedDescription)")
            }
        }
    }


    // MARK: Receiver CRUD Operations

    func createReceiver(name: String, telephoneNumber: String, completion: @escaping (Bool, UUID?) -> Void) {
        let newReceiver = Receiver(context: container.viewContext)
        newReceiver.id = UUID()
        newReceiver.name = name
        newReceiver.telephoneNumber = telephoneNumber

        do {
            try container.viewContext.save()
            completion(true, newReceiver.id) // Return success and the new ID
        } catch {
            print("Error saving Receiver: \(error)")
            completion(false, nil) // Return failure
        }
    }


    func fetchReceivers() -> [Receiver] {
        let request: NSFetchRequest<Receiver> = Receiver.fetchRequest()
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching Receivers: \(error)")
            return []
        }
    }

    func updateReceiver(_ receiver: Receiver, withName name: String, telephoneNumber: String) {
        receiver.name = name
        receiver.telephoneNumber = telephoneNumber
        
        do {
            try container.viewContext.save()
        } catch {
            print("Error updating Receiver: \(error)")
        }
    }

    func deleteReceiver(_ receiver: Receiver) {
        let context = container.viewContext
        context.delete(receiver)
        
        do {
            try context.save()
        } catch {
            print("Error deleting Receiver: \(error)")
        }
    }

    
}
