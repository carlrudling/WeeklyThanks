
import SwiftUI

struct SendFirstCardScreen1View: View {
    var body: some View {
        VStack{
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            Text("Lets send your first thank you card! \nWrite the name and number of the person you want to send to.")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            
            Spacer()
            
          
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )    }
}

#Preview {
    SendFirstCardScreen1View()
}
