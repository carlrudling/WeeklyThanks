
import SwiftUI



struct AfterSentCardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coordinator: NavigationCoordinator
    @State private var navigateToWriteMessageView = false
    @State private var navigateToChoosePersonView = false

    var body: some View {
        VStack{
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            Text("Great reflecting, appreciating the good in other deepends your relationship.")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Spacer()
        
            
            Button(action: {
            
                coordinator.push(.WriteMessage)

                    
            }) {
                    Text("Write another")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
            }
            .padding(.bottom, 20)

            Button(action: {
                coordinator.push(.choosePerson)


                    
            }) {
                    Text("Write to another person")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
            }
            .padding(.bottom, 20)

            Button(action: {
                coordinator.popToRoot()
                    
            }) {
                    Text("Done for this week")
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
