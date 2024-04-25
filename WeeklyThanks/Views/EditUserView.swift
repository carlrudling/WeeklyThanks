
import SwiftUI

struct EditUserView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var coordinator: NavigationCoordinator
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var name: String = "" // For binding to the TextField
    @State private var keyboardIsShown: Bool = false
    @State private var showingImagePicker = false
    @State private var showingCropView = false
    
    
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
                    .padding(.vertical, 15)
                    .foregroundColor(.white)
                
                Button(action: {
                    self.showingImagePicker = true
                }) {
                    if let image = userViewModel.profileImage {
                        ZStack{
                            Image(systemName: "circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 140, height: 140)
                                .foregroundColor(.white)
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130, height: 130)
                                .clipShape(Circle()) // Display the selected image as a circle
                            
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130, height: 130)
                                .foregroundColor(.white.opacity(0.3))
                            
                        }
                        .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)


                    } else {
                        ZStack{
                            
                            Image(systemName: "photo.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 130, height: 130)
                                .foregroundColor(.white.opacity(0.6))
                                .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                            Text("Choose image")
                                .font(.custom("Chillax", size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .sheet(isPresented: $showingImagePicker, onDismiss: {
                    if userViewModel.profileImage != nil {
                        self.showingCropView = true
                    }
                }) {
                    ImagePicker(selectedImage: $userViewModel.profileImage)
                }

                    
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
                
                
                
                Spacer()
                
                
                Button(action: {
                    
                    userViewModel.updateUser(name: userViewModel.name, sendCardGoal: userViewModel.sendCardGoal, profileImage: userViewModel.profileImage)
                    // Proceed with any other actions, like dismissing the view
                    self.presentationMode.wrappedValue.dismiss()
                    
                }) {
                    Text("Save changes")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.gray)
                        .frame(width: 300, height: 50)
                        .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorGreen))
                        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                }
                .padding(.bottom, 30)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen
        
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the background
        )
        .sheet(isPresented: $showingCropView) {
                       CropImageView(image: $userViewModel.profileImage)
                        .edgesIgnoringSafeArea(.all) // Apply this modifier

                   }
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
