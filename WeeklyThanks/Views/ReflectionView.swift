

import SwiftUI

struct ReflectionView: View {

    var body: some View {
            VStack {
                Text("WeeklyThanks")
                    .font(.custom("LeckerliOne-regular", size: 28))
                    .padding(.top, 80)
                    .foregroundColor(.white)
                
                
                Text("Reflect over the week. Anything you want to thank someone for? Remember the small things counts.")
                    .font(.custom("Chillax", size: 16))
                    .padding(.horizontal, 40)
                    .padding(.top, 30)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Spacer()
                
                NavigationLink(destination: ChoosePersonView()) {
                             Text("write a card")
                                 .font(.custom("Chillax", size: 18))
                                 .foregroundColor(.gray)
                                 .frame(width: 300, height: 50)
                                 .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                                
                         }
                
                NavigationLink(destination: HomeView()) {
                    Text("Later")
                        .foregroundColor(.gray)
                        .font(.custom("Chillax", size: 16))
                        .padding(.vertical, 10)
                }
                .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen

            .background(
                LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the background
            )
        
        }
}

struct ReflectionView_Previews: PreviewProvider {
    static var previews: some View {
        ReflectionView()
    }
}
