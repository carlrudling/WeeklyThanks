//
//  AddNewMemberView.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-02-23.
//

import SwiftUI

struct AddNewMemberView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    @State private var navigateToWriteMessage = false // State to control navigation
    @State private var telephoneNumberString: String = "" // For binding to the TextField
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
                Text("Details of the person you want to thank.")
                    .padding(.horizontal, 100)
                    .multilineTextAlignment(.center)
                    .font(.custom("Chillax", size: 16))
                    .padding(.vertical, 60)
                    .foregroundColor(.white)
                
                VStack{
                    
                    
                    // Optionally, use the input text somewhere
                    Text("Name")
                        .font(.custom("Chillax", size: 14))
                        .foregroundColor(.white)
                    
                    TextField("", text: $receiverViewModel.name)
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
                    
                    Text("Telephonenumber")
                        .font(.custom("Chillax", size: 14))
                        .foregroundColor(.white)
                    
                    TextField("", text: $receiverViewModel.telephoneNumber)
                        .background(.white.opacity(0.2))
                        .cornerRadius(8)
                        .frame(width: 180)
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
                    
                    
                    
                    
                }
                Spacer()
                Spacer()

                Button(action: {
                    
                    receiverViewModel.createReceiver(name: receiverViewModel.name, telephoneNumber: receiverViewModel.telephoneNumber)
                    coordinator.push(.WriteMessage)

                }) {
                    Text("Save")
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

struct AddNewMemberView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewMemberView()
    }
}
