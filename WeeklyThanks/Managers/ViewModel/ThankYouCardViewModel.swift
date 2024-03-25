import Foundation
import CoreData

class ThankYouCardViewModel: ObservableObject {
    private let dataManager = DataManager.shared
    @Published var thankYouCards: [ThankYouCard] = []
    
    func createThankYouCard(message: String, writeDate: Date, user: User, receiver: Receiver, count: Int64, theme: String, completion: @escaping (Bool) -> Void) {
        let context = dataManager.container.viewContext
        let newCard = ThankYouCard(context: context)
        newCard.id = UUID()
        newCard.message = message
        newCard.writeDate = writeDate
        newCard.user = user
        newCard.receiver = receiver
        newCard.count = count // Use the passed count parameter directly
        newCard.theme = theme

        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to save the card: \(error.localizedDescription)")
            completion(false)
        }
    }


    func fetchThankYouCards() {
        thankYouCards = dataManager.fetchThankYouCards()
    }
}
