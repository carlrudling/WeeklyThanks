import SwiftUI

struct SentCardsListView: View {
    @EnvironmentObject var thankYouCardViewModel: ThankYouCardViewModel

    var body: some View {
        ZStack {
            // Background
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            // Content
            ScrollView {
                LazyVStack {
                    ForEach(thankYouCardViewModel.thankYouCards, id: \.self) { card in
                        VStack(alignment: .leading) {
                            if let userNickname = card.receiver?.userNickname, !userNickname.isEmpty {
                                ThankYouCardView(scaleFactor: 0.9, message: card.message ?? "", senderName: userNickname, receiverName: card.receiver?.name ?? "", cardNumber: Int(card.count), date: card.writeDate ?? Date())
                                    .padding(.bottom, 15)
                            } else {
                                ThankYouCardView(scaleFactor: 0.9, message: card.message ?? "", senderName: card.user?.name ?? "", receiverName: card.receiver?.name ?? "", cardNumber: Int(card.count), date: card.writeDate ?? Date())
                                    .padding(.bottom, 15)
                            }
                        }
                        .background(Color.clear) // Ensure individual card views have clear background if needed
                        .padding(.horizontal) // Apply padding to match List's default padding
                    }
                }
                .padding(.top) // Optional padding at the top of the list
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
