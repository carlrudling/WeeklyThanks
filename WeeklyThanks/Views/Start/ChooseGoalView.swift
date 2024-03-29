import SwiftUI

struct ChooseGoalView: View {
    @State private var sendCardGoal: Int? // Make this optional and remove the initial value
    var name: String // Assuming you want to keep passing the name to this view

    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack{
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            ZStack{
                ThankYouCardView(scaleFactor: 0.3, message: "", senderName: "", receiverName: "", cardNumber: 1, date: Date())
                    .rotationEffect(.degrees(-15))
                    .offset(x: -30)
                ThankYouCardView(scaleFactor: 0.3, message: "", senderName: "", receiverName: "", cardNumber: 1, date: Date())
                ThankYouCardView(scaleFactor: 0.3, message: "", senderName: "", receiverName: "", cardNumber: 1, date: Date())
                    .rotationEffect(.degrees(15))
                    .offset(x: 30)
            }
            .padding(.top, -50)

            
            Text("How many thank you cards do you want to send each week?")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding(.top, -40)
            
            HStack{
                ForEach(1...3, id: \.self) { number in
                    Button(action: {
                        self.sendCardGoal = number
                    }) {
                        Image(systemName: "\(number).circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(self.sendCardGoal == number ? .backgroundDark : .white)
                            .opacity(self.sendCardGoal == number ? 1.0 : 0.2)
                            .padding(10)
                    }
                }
            }
        
            
            Spacer()
            
            // This NavigationLink will be shown based on some condition or user action
            if let sendCardGoal = sendCardGoal {
                NavigationLink(destination: WeUseNotificationsView(name: name, sendCardGoal: sendCardGoal)) {
                    Text("Next")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.gray)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                        .padding(.bottom, 40)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
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
    }
}

// Usage example for previews
struct ChooseGoalView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseGoalView(name: "Example Name")
    }
}
