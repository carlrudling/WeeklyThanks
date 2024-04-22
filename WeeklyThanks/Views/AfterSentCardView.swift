
import SwiftUI
import StoreKit



struct AfterSentCardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coordinator: NavigationCoordinator
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var navigateToWriteMessageView = false
    @State private var navigateToChoosePersonView = false
    
    @State private var selectedQuote = ""
    @State private var quoteOpacity = 0.0
    @State private var quoteOffset = 20.0

    let quotes = [
        "“I would maintain that thanks are the highest form of thought and that gratitude is happiness doubled by wonder.” \n— Gilbert K. Chesterton",
        "“The unthankful heart discovers no mercies; but the thankful heart will find, in every hour, some heavenly blessings.” \n— Henry Ward Beecher",
        "“Appreciation can make a day—even change a life. Your willingness to put it into words is all that is necessary.” \n— Margaret Cousins",
        "“Thankfulness is the beginning of gratitude. Gratitude is the completion of thankfulness. Thankfulness may consist merely of words. Gratitude is shown in acts.” \n— Henri-Frédéric Amiel",
        "“The chief idea of my life is the idea of taking things with gratitude, and not taking things for granted.” \n— Gilbert K. Chesterton",
        "“No one who achieves success does so without the help of others. The wise and confident acknowledge this help with gratitude.” \n— Alfred North Whitehead",
        "“The roots of all goodness lie in the soil of appreciation for goodness.” \n— Dalai Lama",
        "“Gratitude is the fairest blossom which springs from the soul.” \n— Henry Ward Beecher",
        "“Some people grumble that roses have thorns; I am grateful that thorns have roses.” \n— Jean-Baptiste Alphonse Karr",
        "“Let us be grateful to the people who make us happy, they are the charming gardeners who make our Souls blossom.” \n— Marcel Proust",
        "“Be grateful for whoever comes, because each has been sent as a guide from beyond.” \n— Rumi",
        "“Wear gratitude like a cloak and it will feed every corner of your life.” \n— Rumi",
        "“Gratitude is the wine for the soul. Go on. Get drunk.” \n— Rumi",
        "“Thankfulness brings you to the place where the Beloved lives.” \n— Rumi",
        "“Today, let us swim wildly, joyously in gratitude.” \n— Rumi",
        "“A grateful mind is a great mind which eventually attracts to itself great things.” \n— Plato",
        "“Appreciation is a wonderful thing. It makes what is excellent in others belong to us as well.” \n— Voltaire",
        "“Gratitude is not only the greatest of virtues, but the parent of all the others.” \n— Cicero",
        "“If the only prayer you said in your whole life was, ‘Thank you,’ that would suffice.” \n— Meister Eckhart",
        "“I can no other answer make, but, thanks, And thanks, and ever thanks.” \n— William Shakespeare",
        "“Feeling gratitude and not expressing it is like wrapping a present and not giving it.” \n— William Arthur Ward",
        "“No duty is more urgent than giving thanks.” \n— James Allen",
        "“We would worry less if we praised more. Thanksgiving is the enemy of discontent and dissatisfaction.” \n— Harry A. Ironside",
        "“The soul that gives thanks can find comfort in everything; the soul that complains can find comfort in nothing.” \n— Hannah Whitall Smith",
        "“Enough is a feast.” \n— Buddhist Proverb",
        "“If you can’t reward then you should thank.” \n— Arabic Proverb",
        "“Give thanks for a little and you will find a lot.” \n— Hausa Proverb",
        "“When eating fruit, remember the one who planted the tree.” \n— Vietnamese Proverb",
        "“Who does not thank for little will not thank for much.” \n— Estonian Proverb",
        "“A noble person is mindful and thankful for the favors he receives from others.” \n— Buddha",
        "“Let us rise up and be thankful, for if we didn’t learn a lot today, at least we learned a little.” \n— Buddha",
        "“You have no cause for anything but gratitude and joy.” \n— Buddha Proverb",
            
    ]

    
    var body: some View {
        VStack{
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            Text(selectedQuote)
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .opacity(quoteOpacity)
                .offset(y: quoteOffset) // Adjust the value as needed to move the text up
                .onAppear {
                    // Start the animations when the view appears
                    withAnimation(.easeOut(duration: 2)) {
                        quoteOpacity = 1.0 // Fade in to full opacity
                        quoteOffset = 0.0 // Move up to its original position
                    }
                }
            Spacer()
        
            
            Button(action: {
            
                coordinator.push(.WriteMessage)

                    
            }) {
                    Text("Write another card")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
            }
            .padding(.bottom, 20)

            Button(action: {
                coordinator.push(.choosePerson)


                    
            }) {
                    Text("Write to another friend")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
            }
            .padding(.bottom, 20)

            Button(action: {
                coordinator.popToRoot()
                    
            }) {
                    Text("Done for now")
                        .font(.custom("Chillax", size: 16))
                        .foregroundColor(.gray)
                        .padding() // Apply padding inside the HStack to ensure space around text and icon
                        .frame(width: 250, height: 40)
                        
            }
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen
      
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the background
        )
        .onAppear{
            selectedQuote = quotes.randomElement() ?? ""
            print(userViewModel.sendCardGoal)
            print(userViewModel.sentCardsThisWeek)
            UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                print("Pending notification requests: \(requests)")
            }
            if userViewModel.sentCardsThisWeek == userViewModel.sendCardGoal {
                           // Call the notification method
                           NotificationManager.shared.congratulateForReachingGoal()
                       }
            if userViewModel.count == 3 || userViewModel.count == 15 {
                if let windowScene = UIApplication.shared.windows.first?.windowScene {
                          SKStoreReviewController.requestReview(in: windowScene)
                      }
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
    AfterSentCardView()
}
