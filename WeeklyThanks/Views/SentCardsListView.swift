import SwiftUI

struct SentCardsListView: View {
    @EnvironmentObject var thankYouCardViewModel: ThankYouCardViewModel
    @State private var selectedCard: ThankYouCard?
    @State private var showZoomedCardView = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            if thankYouCardViewModel.thankYouCards.isEmpty {
                Text("No cards have been sent yet.")
                    .padding()
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 16))
            } else {
                ScrollView(showsIndicators: false) {
                    LazyVStack {
                        ForEach(thankYouCardViewModel.thankYouCards, id: \.self) { card in
                            ThankYouCardView(scaleFactor: 0.9, message: card.message ?? "", senderName: card.user?.name ?? "", receiverName: card.receiver?.name ?? "", cardNumber: Int(card.count), date: card.writeDate ?? Date(), theme: card.theme ?? "normal")
                                .padding(.bottom, 15)
                        }
                    }
                    .padding(.top)
                }
            }
       }
        .onAppear {
            thankYouCardViewModel.fetchThankYouCards()
            
        }
    }
}

// Helper to format the date
private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct SentCardsListView_Previews: PreviewProvider {
    static var previews: some View {
        SentCardsListView()
            .environmentObject(ThankYouCardViewModel())
    }
}
