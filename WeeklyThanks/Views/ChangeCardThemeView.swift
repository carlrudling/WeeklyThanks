import SwiftUI


struct ChangeCardThemeView: View {
    
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(thankYouCardViewModel.themes, id: \.self) { theme in
                        ThankYouCardView(
                            scaleFactor: 0.9,
                            message: thankYouCardViewModel.message,
                            senderName: userViewModel.name,
                            receiverName: receiverViewModel.name,
                            cardNumber: userViewModel.count + 1,
                            date: Date(),
                            theme: theme
                            
                        )
                        .padding(.bottom, 15)
                        .onTapGesture {
                            // Set the selected theme when a card is tapped
                            thankYouCardViewModel.selectedTheme = theme
                            isPresented = false // <-- This will dismiss the view

                        }
                    }
                }
                .padding(.top)
            }
        }
    }
}
//#Preview {
//    
//    ChangeCardThemeView(isPresented: bool)
//}
