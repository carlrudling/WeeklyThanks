
import SwiftUI

struct ThankMeBoardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coordinator: NavigationCoordinator
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel


    @State private var textOpacity = 0.0
    @State private var textOffset = 20.0
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private let currentDate = Date()  // Capture the current date once when the view is loaded

    
    var body: some View {
        VStack{
        ScrollView{
            Text("Thank Me Board")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.vertical, 35)
                .foregroundColor(.white)
            
                
                if thankYouCardViewModel.thankYouCards.isEmpty {
                    Text("Start a habit to thank yourself and build a thank me board filled with self-appreciation.")
                        .font(.custom("Chillax", size: 16))
                        .padding(.horizontal, 40)
                        .padding(.top, 30)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .opacity(textOpacity)
                        .offset(y: textOffset)
                        .onAppear {
                            withAnimation(.easeOut(duration: 2)) {
                                textOpacity = 1.0
                                textOffset = 0.0
                            }
                        }
                } else {
                
                        HStack{
                            Text(currentDate.formatted(as: "yyyy")) // Current Year
                                .foregroundStyle(Color.clear)
                                .font(.custom("Chillax", size: 12))
                            Spacer()
                            Text(currentDate.formatted(as: "MMMM")) // Current Month in full letters
                                .font(.custom("Chillax", size: 16))
                            
                            Spacer()
                            Text(currentDate.formatted(as: "yyyy")) // Current Year
                                .font(.custom("Chillax", size: 12))
                            
                        }
                        .padding(.horizontal, 10)
//                        ScrollView {
                            LazyVGrid(columns: columns) {
                                ForEach(thankYouCardViewModel.thankYouCards, id: \.self) { card in
                                    ThankYouCardView(
                                        scaleFactor: 0.3,
                                        message: card.message ?? "",
                                        senderName: card.user?.name ?? "",
                                        receiverName: card.receiver?.name ?? "",
                                        cardNumber: Int(card.count),
                                        date: card.writeDate ?? Date(),
                                        theme: card.theme ?? ""
                                    )
                                    .padding(.vertical, -95)
                                    .opacity(textOpacity)
                                    .offset(y: textOffset)
                                    .onAppear {
                                        withAnimation(.easeOut(duration: 2)) {
                                            textOpacity = 1.0
                                            textOffset = 0.0
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 10)
                            
                        
                    }
                }
            Spacer()
                Button {
                    if userViewModel.hasProfileImage {
                        coordinator.push(.writeThankMe) // Navigate to writing a thank-you card
                    } else {
                        coordinator.push(.addProfileImage) // Navigate to add a profile image
                    }
                    
                } label: {
                    HStack{
                        Image(systemName: "pencil")
                            .font(.custom("Chillax", size: 18))
                            .foregroundColor(.clear)
                        Text("write a card")
                            .font(.custom("Chillax", size: 18))
                            .foregroundColor(.gray)
                        Image(systemName: "pencil")
                            .font(.custom("Chillax", size: 18))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                    .padding(.bottom, 40)
                }
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundDarkBlue, .backgroundLightBlue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
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
        .onAppear {
                   // Fetch the cards intended for self-appreciation
                   thankYouCardViewModel.fetchThankYouCardsSentToSelf()
               }
    }
}

extension Date {
    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

#Preview {
    ThankMeBoardView()
}
