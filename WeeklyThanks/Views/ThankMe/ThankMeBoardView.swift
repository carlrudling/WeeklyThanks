
import SwiftUI

struct ThankMeBoardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coordinator: NavigationCoordinator
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel


    @State private var selectedCard: ThankYouCard?
    @State private var showCarousel = false
    
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    private let currentDate = Date()  // Capture the current date once when the view is loaded

    
    //    ANIMATIONS
    @State private var textOpacity = 0.0
    @State private var textOffset = 20.0
    @State private var isAnimating = false
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var movePencil = false
    @State private var showDots = false
    
    private func startAnimationSequence() {
           withAnimation(.easeInOut(duration: 0.5)) {
               movePencil.toggle()  // Move the pencil
               showDots.toggle()  // Show or hide the dots

           }
           DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
               withAnimation(.easeInOut(duration: 0.5)) {
                   movePencil = false
                   showDots = false
               }
           }
       }
    
    var body: some View {
        VStack{
        ScrollView{
          
                Text("Thank Me Board")
                    .font(.custom("LeckerliOne-regular", size: 28))
                    .padding(.vertical, 10)
                    .foregroundColor(.white)
            
            if let profileImage = userViewModel.profileImage {
                ZStack{
                    Image(systemName: "circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                    Image(uiImage: profileImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .clipShape(Circle()) // Display the selected image as a circle
                }
                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
            } else {
                Image(systemName: "photo.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 110, height: 110)
                    .foregroundColor(.white.opacity(1.0))
            }
                
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
                                .foregroundStyle(Color.white)
                            
                            Spacer()
                            Text(currentDate.formatted(as: "yyyy")) // Current Year
                                .font(.custom("Chillax", size: 12))
                                .foregroundStyle(Color.white)

                            
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
                                    .onTapGesture {
                                            selectedCard = card
                                            showCarousel = true
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
                        Text(showDots ? "..." : "")
                               .font(.custom("Chillax", size: 18))
                               .opacity(showDots ? 1 : 0)
                        Image(systemName: "pencil")
                            .font(.custom("Chillax", size: 18))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .padding(.bottom, 40)
                }
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundDarkBlue, .backgroundLightBlue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .sheet(isPresented: $showCarousel) {
                    CarouselView(selectedCard: $selectedCard, cards: thankYouCardViewModel.thankYouCards)
                }        .navigationBarBackButtonHidden(true)
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
        .onReceive(timer) { _ in
            startAnimationSequence()
            isAnimating = true
            withAnimation(.easeInOut(duration: 0.6).repeatCount(3, autoreverses: true)) {
                isAnimating = false
            }
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


struct CarouselView: View {
    @Binding var selectedCard: ThankYouCard?
    var cards: [ThankYouCard]

    var body: some View {
        TabView(selection: $selectedCard) {
            ForEach(cards, id: \.self) { card in
                ThankYouCardView(
                    scaleFactor: 0.9, // Full scale for carousel view
                    message: card.message ?? "",
                    senderName: card.user?.name ?? "",
                    receiverName: card.receiver?.name ?? "",
                    cardNumber: Int(card.count),
                    date: card.writeDate ?? Date(),
                    theme: card.theme ?? ""
                )
                .tag(card) // Tag each card view with its corresponding ThankYouCard object
                .padding()
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundDarkBlue, .backgroundLightBlue]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
}
