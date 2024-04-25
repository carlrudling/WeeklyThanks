
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator

    @State private var showingSentCardsListView = false
    @State private var showingEditUserView = false

    //    ANIMATIONS
    @State private var isAnimating = false
    @State private var timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    @State private var movePencil = false
    @State private var showDots = false
    @State private var quoteOpacity = 0.0
    @State private var quoteOffset = 20.0
    
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
            
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            
            Text("Reflect on the week. Is there anything you want to thank someone for? Remember, even small things count.")
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
            
            HStack{
              
                if userViewModel.count == 1 {
                    Text("\(userViewModel.count) card sent")
                        .font(.custom("Chillax", size: 12))
                        .padding(.top, 5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                } else {
                    Text("\(userViewModel.count) cards sent")
                        .font(.custom("Chillax", size: 12))
                        .padding(.top, 5)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
                
                Image(systemName: "heart.fill")
                    .foregroundColor(Color.buttonColorLight)
                    .font(.system(size: 12))
            }
            
            Text("Weekly goal:")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            if userViewModel.sendCardGoal > 0 {
                HStack {
                    ForEach(1...userViewModel.sendCardGoal, id: \.self) { number in
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 30))
                            // Change the color to green if sentCardsThisWeek >= sendCardGoal, otherwise white
                            .foregroundColor(userViewModel.sentCardsThisWeek >= userViewModel.sendCardGoal ? .buttonColorGreen : .white)
                            // The opacity condition remains the same to indicate progress towards the goal
                            .opacity(number <= userViewModel.sentCardsThisWeek ? 1.0 : 0.2)
                            .padding(10)
                    }
                }
            }


            


            
            Spacer()
            Button {
                coordinator.push(.thankMeBoard) // Navigate to the details screen

            } label: {
                HStack{
                    Image(systemName: "sparkles")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.clear)
                    Text("thank me board")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.white)
                    Image(systemName: "sparkles")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.white)
                        .scaleEffect(isAnimating ? 1.5 : 1.0)
                        .animation(.easeInOut(duration: 0.8).repeatCount(3, autoreverses: true), value: isAnimating)

                      
                }
                .frame(width: 300, height: 50)
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.backgroundDarkBlue))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                .padding(.bottom, 10)
                .onAppear {
                    isAnimating = true
                }
            }

            
            Button {
                coordinator.push(.choosePerson) // Navigate to the details screen

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
        
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen

        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the background
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // HERE is WHERE THE ACTION IS TO EDITUSERVIEW
                    self.showingEditUserView = true
                }
                    ) {
                 
                        Image(systemName: "gearshape")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(10)
                        
                
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    self.showingSentCardsListView = true
                }
                    ) {
                 
                        Image(systemName: "paperplane")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(10)
                        
                
                }
            }
        }
        .onAppear {
                    userViewModel.fetchCurrentUser()

                    if let currentUser = userViewModel.currentUser {
                        userViewModel.name = currentUser.name ?? ""
                        userViewModel.sendCardGoal = Int(currentUser.sendCardGoal)
                        userViewModel.sentCardsThisWeek = Int(currentUser.sentCardsThisWeek)
                    }

                }
        .onReceive(timer) { _ in
            startAnimationSequence()
            isAnimating = true
            withAnimation(.easeInOut(duration: 0.6).repeatCount(3, autoreverses: true)) {
                isAnimating = false
            }
        }
       


        .sheet(isPresented: $showingSentCardsListView) {
            // Make sure to inject the necessary EnvironmentObjects or any other dependencies
            SentCardsListView().environmentObject(thankYouCardViewModel)
        }
        .sheet(isPresented: $showingEditUserView) {
            // Make sure to inject the necessary EnvironmentObjects or any other dependencies
            EditUserView().environmentObject(userViewModel)
        }

        
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static var previews: some View {
        let userViewModel = UserViewModel()

        HomeView()
            .environmentObject(userViewModel)

    }
}
