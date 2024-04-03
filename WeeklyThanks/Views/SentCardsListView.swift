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
                            ThankYouCardView(scaleFactor: 0.9, message: card.message ?? "", senderName: card.user?.name ?? "", receiverName: card.receiver?.name ?? "", cardNumber: Int(card.count), date: card.writeDate ?? Date())
                                .padding(.bottom, 15)
                                .onTapGesture {
                                    withAnimation {
                                        self.selectedCard = card
                                        self.showZoomedCardView = true
                                    }
                                }
                        }
                    }
                    .padding(.top)
                }
            }
            if showZoomedCardView{
                Color.black.opacity(0.4)
                    .frame(width: .infinity, height: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        withAnimation {
                            self.showZoomedCardView = false
                        }
                    }
            }
            // Overlay for the zoomed card view
            if showZoomedCardView, let selectedCard = selectedCard {
                ThankYouCardView(scaleFactor: 1.0, message: selectedCard.message ?? "", senderName: selectedCard.user?.name ?? "", receiverName: selectedCard.receiver?.name ?? "", cardNumber: Int(selectedCard.count), date: selectedCard.writeDate ?? Date())
                    .onTapGesture {
                        withAnimation {
                            self.showZoomedCardView = false
                        }
                    }
                    .scaleEffect(showZoomedCardView ? 1 : 0.1)
                    .opacity(showZoomedCardView ? 1 : 0)
                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            }
        }
        .onAppear {
            thankYouCardViewModel.fetchThankYouCards()
        }
    }
}

// Ensure you have defined ThankYouCardView and ThankYouCardViewModel properly.
// This example assumes ThankYouCardView can display the card's details based on the passed parameters.




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
