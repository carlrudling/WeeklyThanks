

import SwiftUI

struct ExplanationView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View{
        VStack{
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            ZStack{
                ThankYouCardView(scaleFactor: 0.3, message: "", senderName: "", receiverName: "", cardNumber: 1, date: Date(), theme: "normal")
                    .rotationEffect(.degrees(-15))
                    .offset(x: -30)
                ThankYouCardView(scaleFactor: 0.3, message: "", senderName: "", receiverName: "", cardNumber: 1, date: Date(), theme: "normal")
                ThankYouCardView(scaleFactor: 0.3, message: "", senderName: "", receiverName: "", cardNumber: 1, date: Date(), theme: "normal")
                    .rotationEffect(.degrees(15))
                    .offset(x: 30)
            }
            .padding(.top, -50)
            
            Text("Everyone loves a thank you. Start the habit of sending weekly thank you cards to your friends and share your gratitude.")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, -40)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            
            Spacer()
            
            NavigationLink(destination: AddNameView()) {
                Text("Next")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
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
    ExplanationView()
}
