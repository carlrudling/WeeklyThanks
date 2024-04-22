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
                    coordinator.push(.thankMeBoard)
                    
                    
                }) {
                    HStack {
                        Image(systemName: "chevron.forward") // Replace with your icon
                            .foregroundColor(.clear)
                        Spacer()
                        Text("Choose card design")
                            .font(.custom("Chillax", size: 18))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.forward") // Replace with your icon
                            .foregroundColor(.white)
                    }
                    .padding() // Apply padding inside the HStack to ensure space around text and icon
                    .frame(width: 250, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundDarkBlue))
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
