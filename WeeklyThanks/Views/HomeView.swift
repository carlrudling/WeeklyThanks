
import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator

    @State private var showingSentCardsListView = false

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
              
                
                Text("\(userViewModel.count) cards sent")
                    .font(.custom("Chillax", size: 12))
                    .padding(.top, 5)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Image(systemName: "heart.fill")
                    .foregroundColor(Color.buttonColorLight)
                    .font(.system(size: 12))
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
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // HERE is WHERE THE ACTION IS
                    self.showingSentCardsListView = true
                }
                    ) {
                    ZStack{
                        Image(systemName: "paperplane")
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .padding(12)
                        
                        Image(systemName: "rectangle")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(12)
                    }
                }
            }
        }
        .onAppear {
                    userViewModel.fetchCurrentUser()
                }
        .sheet(isPresented: $showingSentCardsListView) {
            // Make sure to inject the necessary EnvironmentObjects or any other dependencies
            SentCardsListView().environmentObject(thankYouCardViewModel)
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
