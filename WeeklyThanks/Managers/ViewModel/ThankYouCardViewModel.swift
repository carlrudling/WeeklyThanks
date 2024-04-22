import Foundation
import CoreData

class ThankYouCardViewModel: ObservableObject {
    private let dataManager = DataManager.shared
    @Published var thankYouCards: [ThankYouCard] = []
    @Published var selectedTheme: String = "normal"
    @Published var themes: [String] = ["normal", "lotus", "greenFlowers", "omSymbol", "redHearts", "lotusStones"]
    @Published var message: String = ""

    func createThankYouCard(message: String, writeDate: Date, user: User, receiver: Receiver, count: Int64, theme: String, sentToSelf: Bool, completion: @escaping (Bool) -> Void) {
        let context = dataManager.container.viewContext
        let newCard = ThankYouCard(context: context)
        newCard.id = UUID()
        newCard.message = message
        newCard.writeDate = writeDate
        newCard.user = user
        newCard.receiver = receiver
        newCard.count = count
        newCard.theme = theme
        newCard.sentToSelf = sentToSelf // Set the new boolean attribute

        do {
            try context.save()
            completion(true)
        } catch {
            print("Failed to save the card: \(error.localizedDescription)")
            completion(false)
        }
    }


    
    func fetchThankYouCardsSentToSelf() {
        thankYouCards = dataManager.fetchThankYouCardsSentToSelf()
    }

    func fetchThankYouCardsNotSentToSelf() {
        thankYouCards = dataManager.fetchThankYouCardsNotSentToSelf()
    }
}
