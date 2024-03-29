
import SwiftUI

struct AddNameView: View {
    @State private var inputText: String = ""
    @State private var navigateToUseNotification = false // State to control navigation
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var keyboardIsShown: Bool = false
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        
        ZStack {
            // Invisible layer that will only react when the keyboard is shown
            if keyboardIsShown {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        // Hide the keyboard when the clear area is tapped
                        hideKeyboard()
                        keyboardIsShown = false // Update the state
                        
                    }
                    .zIndex(5) // Make sure this is above the form
                    .frame(width: 300, height: 300)
            }
            VStack{
                Text("WeeklyThanks")
                    .font(.custom("LeckerliOne-regular", size: 28))
                    .padding(.top, 35)
                    .foregroundColor(.white)
                
                
                Text("For starters, \nWhat's your name?")
                    .font(.custom("Chillax", size: 16))
                    .padding(.horizontal, 40)
                    .padding(.top, 60)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                TextField("", text: $inputText)
                    .background(.white.opacity(0.2))
                    .cornerRadius(8)
                    .frame(width: 150)
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 20))
                    .cornerRadius(8)
                    .frame(width: 150)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .onTapGesture {
                        // When tapping on the TextField, indicate that the keyboard is shown
                        keyboardIsShown = true
                    }
                
                
                
                
                Spacer()
                
                
                NavigationLink(destination: ChooseGoalView(name: inputText)) {
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

struct AddNameView_Previews: PreviewProvider {
    static var previews: some View {
            AddNameView()
    }
}
