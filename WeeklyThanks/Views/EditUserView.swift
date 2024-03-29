
import SwiftUI

struct EditUserView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coordinator: NavigationCoordinator
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var name: String = "" // For binding to the TextField
    @State private var keyboardIsShown: Bool = false

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
                Text("Edit user details")
                    .padding(.horizontal, 100)
                    .multilineTextAlignment(.center)
                    .font(.custom("Chillax", size: 16))
                    .padding(.vertical, 80)
                    .foregroundColor(.white)
                
                VStack{
                    
                    
                    // Optionally, use the input text somewhere
                    Text("Name")
                        .font(.custom("Chillax", size: 14))
                        .foregroundColor(.white)
                    
                    TextField("", text: $userViewModel.name)
                        .background(.white.opacity(0.2))
                        .cornerRadius(8)
                        .frame(width: 150)
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 20))
                        .cornerRadius(8)
                        .frame(width: 150)
                        .padding(.bottom, 20)
                        .multilineTextAlignment(.center)
                        .onTapGesture {
                            // When tapping on the TextField, indicate that the keyboard is shown
                            keyboardIsShown = true
                        }
                    
                    Text("Choose your weekly goal")
                        .font(.custom("Chillax", size: 14))
                        .foregroundColor(.white)
                        .padding(.top, 30)
                        .padding(.bottom, 20)
                    
                    HStack(spacing: 20) {
                        ForEach(1...3, id: \.self) { number in
                            Button(action: {
                                userViewModel.sendCardGoal = number
                            }) {
                                Image(systemName: "\(number).circle.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(userViewModel.sendCardGoal == number ? .backgroundDark : .white)
                                    .opacity(userViewModel.sendCardGoal == number ? 1.0 : 0.2)
                            }
                        }
                    }.padding(.bottom, 20)
                }
                Spacer()
                
                
                Button(action: {
                    
                    userViewModel.updateUser(name: userViewModel.name, sendCardGoal: userViewModel.sendCardGoal)
                    // Proceed with any other actions, like dismissing the view
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Save changes")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.gray)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorGreen))
                }
                .padding(.bottom, 30)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen
        
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the background
        )
        .onAppear {
            if let currentUser = userViewModel.currentUser {
                userViewModel.name = currentUser.name ?? ""
                // Since sendCardGoal is an Int64, directly assign it by casting to Int
                userViewModel.sendCardGoal = Int(currentUser.sendCardGoal)
            }
        }


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
    EditUserView()
}
