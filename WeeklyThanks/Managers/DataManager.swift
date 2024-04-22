
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

    
    func createThankYouCard(message: String, writeDate: Date, user: User, receiver: Receiver, count: Int64, theme: String, sentToSelf: Bool, completion: @escaping (Bool) -> Void) {
        let context = container.viewContext
        let newCard = ThankYouCard(context: context)
        newCard.id = UUID()
        newCard.message = message
        newCard.writeDate = writeDate
        newCard.user = user
        newCard.receiver = receiver
        newCard.count = count // Set the count attribute
        newCard.theme = theme
        newCard.sentToSelf = sentToSelf

        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to save the card: \(error.localizedDescription)")
            completion(false)
        }
    }


    
    func fetchThankYouCardsSentToSelf() -> [ThankYouCard] {
        return fetchThankYouCards(with: NSPredicate(format: "sentToSelf == YES"))
    }

    func fetchThankYouCardsNotSentToSelf() -> [ThankYouCard] {
        return fetchThankYouCards(with: NSPredicate(format: "sentToSelf == NO || sentToSelf == nil"))
    }

    private func fetchThankYouCards(with predicate: NSPredicate) -> [ThankYouCard] {
        let request: NSFetchRequest<ThankYouCard> = ThankYouCard.fetchRequest()
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "writeDate", ascending: false)
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
    func createUser(name: String, email: String, password: String, count: Int, sendCardGoal: Int, goalWeekStrike: Int, sentCardsThisWeek: Int, lastSentCard: Date, selfSentCardCount: Int = 0, profileImage: UIImage? = nil, completion: @escaping (Bool) -> Void) {
        let newUser = User(context: container.viewContext)
        newUser.id = UUID()
        newUser.name = name
        newUser.email = email
        newUser.password = password
        newUser.count = Int64(count)
        newUser.sendCardGoal = Int64(sendCardGoal)
        newUser.goalWeekStrike = Int64(goalWeekStrike)
        newUser.sentCardsThisWeek = Int64(sentCardsThisWeek)
        newUser.lastSentCard = lastSentCard
        newUser.selfSentCardCount = Int64(selfSentCardCount)  // Assuming Core Data uses Int64 for counts
        if let image = profileImage {
            newUser.profileImage = image.jpegData(compressionQuality: 0.5)
        }

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

    func updateUser(_ user: User, withName name: String?, email: String?, password: String?, profileImage: UIImage?) {
        if let name = name {
            user.name = name
        }
        if let email = email {
            user.email = email
        }
        if let password = password {
            user.password = password
        }
        if let profileImage = profileImage {
            user.profileImage = profileImage.jpegData(compressionQuality: 0.5) // Adjust compression quality as needed
        }
        
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
