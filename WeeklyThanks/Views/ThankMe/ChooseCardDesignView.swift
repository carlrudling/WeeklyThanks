import SwiftUI

struct ChooseCardDesignView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator

    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    @State private var dynamicSize: CGSize = CGSize(width: 360, height: 240) // Default size
    @State private var updateViewID = UUID()


    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.backgroundDarkBlue, .backgroundLightBlue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            ScrollView {
                ThankYouCardView(scaleFactor: 0.9, message: thankYouCardViewModel.message, senderName: "me", receiverName: "me", cardNumber: userViewModel.selfSentCardCount + 1, date: Date(), theme: thankYouCardViewModel.selectedTheme)
                    .id(updateViewID) // Force redraw
                    .frame(width: dynamicSize.width, height: dynamicSize.height)
                    .padding(.top, 10)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(thankYouCardViewModel.themes, id: \.self) { theme in
                        ThankYouCardView(
                            scaleFactor: 0.4,
                            message: thankYouCardViewModel.message,
                            senderName: "me",
                            receiverName: "me",
                            cardNumber: userViewModel.selfSentCardCount + 1,
                            date: Date(),
                            theme: theme
                            
                        )
                        .padding(.vertical, -70)
                        .onTapGesture {
                            // Set the selected theme when a card is tapped
                            thankYouCardViewModel.selectedTheme = theme

                        }
                    }
                }
            }
            
            VStack{
                Spacer()
                
                Button(action: {
                    
                    
                    if let user = self.userViewModel.currentUser {
                        thankYouCardViewModel.createThankYouCard(
                           message: self.thankYouCardViewModel.message,
                            writeDate: Date(), // Current date
                            user: user, // Safely unwrapped User
                            receiver: nil,
                           count: Int64(self.userViewModel.selfSentCardCount + 1), theme: thankYouCardViewModel.selectedTheme, sentToSelf: true,// Safely unwrapped Receiver
                            completion: { success in
                                // Handle success or failure
                                if success {
                                    print("Card saved successfully")
                                    // Perform additional actions, like navigating away or showing a success message
                               
                                } else {
                                    print("Failed to save the card")
                                    // Handle failure, such as showing an error message
                                }
                            }
                        )
                       self.userViewModel.incrementSelfSentCardCount()
                       self.thankYouCardViewModel.message = ""
                        coordinator.push(.thankMeBoard)

                    }
                    
                }) {
                    HStack {
                        Image(systemName: "pin.fill") // Replace with your icon
                            .foregroundColor(.clear)
                        Spacer()
                        Text("Pin on board")
                            .font(.custom("Chillax", size: 18))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "pin.fill") // Replace with your icon
                            .foregroundColor(.white)
                    }
                    .padding() // Apply padding inside the HStack to ensure space around text and icon
                    .frame(width: 250, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardColorDark))
                }
                .padding(.bottom, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
        }
    }
}



#Preview {
    ChooseCardDesignView()
        .environmentObject(ThankYouCardViewModel())
}
