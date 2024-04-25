

import SwiftUI

struct StartView: View {
    
    var body: some View {
        VStack{
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 80)
                .foregroundColor(.white)
            
            
            Text("Practise gratitude and deepen your relationships.")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            
            Spacer()
            
            NavigationLink(destination: ExplanationView()) {
                         Text("Start")
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
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
