
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator

    @State private var showingSentCardsListView = false
    @State private var showingEditUserView = false

    
  

    var body: some View {
        VStack{
            
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            
            Text("Reflect over the week. Anything you want to thank someone for? Remember the small things counts.")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            HStack{
              
                if userViewModel.count <= 2 {
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
                coordinator.push(.choosePerson) // Navigate to the details screen

            } label: {
                Text("write a card")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
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
                    // HERE is WHERE THE ACTION IS
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
//            let formatter = DateFormatter()
//            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//            // Convert the lastSentCard date to a String
//            let dateString = formatter.string(from: UserViewModel.lastSentCard)
            print(userViewModel.lastSentCard)

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
