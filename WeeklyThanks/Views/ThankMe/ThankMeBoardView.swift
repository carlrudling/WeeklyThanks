
import SwiftUI

struct ThankMeBoardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coordinator: NavigationCoordinator


    @State private var textOpacity = 0.0
    @State private var textOffset = 20.0
    
    var body: some View {
        VStack{
            Text("Thank me board")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            Text("Start a habit to thank yourself and build a thank me board filled with self appreciation")
                .font(.custom("Chillax", size: 16))
                .padding(.horizontal, 40)
                .padding(.top, 30)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .opacity(textOpacity)
                .offset(y: textOffset) 
                .onAppear {
                    // Start the animations when the view appears
                    withAnimation(.easeOut(duration: 2)) {
                        textOpacity = 1.0 // Fade in to full opacity
                        textOffset = 0.0 // Move up to its original position
                    }
                }
            
            Spacer()
            
            Button {
                coordinator.push(.writeThankMe) // Navigate to the details screen

            } label: {
                Text("write a card")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                    .padding(.bottom, 40)
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

#Preview {
    ThankMeBoardView()
}
