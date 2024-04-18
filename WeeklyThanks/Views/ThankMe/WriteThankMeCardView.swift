//
//  WriteThankMeCardView.swift
//  WeeklyThanks
//
//  Created by Carl Rudling on 2024-04-17.
//

import SwiftUI

struct WriteThankMeCardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showingMessageComposer = false
    @State private var showChangeCardView = false
    @State private var recipients = [""]
    @State private var bodyImage: UIImage?
    @State private var keyboardIsShown: Bool = false
    @State private var presentedImage: IdentifiableImage?
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator

    @State private var showingEditReceiverView = false

    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var body: some View {
        
        ZStack{
            if keyboardIsShown {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                        keyboardIsShown = false // Update the state
                        
                    }
                    .zIndex(5) // Make sure this is above the form
                    .frame(width: 300, height: 300)
            }
            VStack {
                
                //                  HERE IS WHERE THE IMAGE 
                
                
                Text("To \(receiverViewModel.name)")
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 14))
                Rectangle()
                    .frame(height: 1) // Make the rectangle thin, like a line
                    .foregroundColor(.white) // Set the line color
                    .frame(width: 50 )
                    .padding(.top, -10)
                
                ZStack {
                    TextEditor(text: $thankYouCardViewModel.message)
                        .onChange(of: thankYouCardViewModel.message) { newValue in
                            if newValue.count > 150 { // Limit to 150 characters
                                thankYouCardViewModel.message = String(newValue.prefix(150))
                            }
                            self.dynamicSize = calculateDynamicSize(for: thankYouCardViewModel.message)
                            self.updateViewID = UUID()
                        }
                        .font(.custom("Chillax", size: 16)) // Adjust font size dynamically
                        .background(.white.opacity(0.2))
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .frame(height: 200)
                        .onTapGesture {
                            // When tapping on the TextField, indicate that the keyboard is shown
                            keyboardIsShown = true
                        }
                    
                    
                }
                .frame(height: 200)
                .padding(.horizontal, 20)
                .padding(.top, 10)
                HStack{
                    Spacer()
                    if thankYouCardViewModel.message.count == 0 {
                        Text("Max 150 characters")
                            .foregroundColor(.white)
                            .font(.custom("Chillax", size: 14))
                            .padding(.trailing, 20)
                    } else {
                        HStack{
                            Text("\(thankYouCardViewModel.message.count)/150") // Show the current count out of the max characters allowed
                                .foregroundColor(thankYouCardViewModel.message.count == 150 ? .red : .white) // Change color to red if over 150 characters, otherwise white
                                .font(.custom("Chillax", size: 14))
                                .padding(.trailing, 20)
                        }
                    }
                }
                
                
                VStack{
                    Text("/ \(userViewModel.name)")
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 14))
                    Rectangle()
                        .frame(height: 1) // Make the rectangle thin, like a line
                        .foregroundColor(.white) // Set the line color
                        .frame(width: 50 )
                        .padding(.top, -10)
                }
                .padding(.top, 10)
                
                Spacer()
                
                Button(action: {
                    coordinator.push(.chooseDesign)
                    
                    
                }) {
                    HStack {
                        Image(systemName: "chevron.foreward") // Replace with your icon
                            .foregroundColor(.clear)
                        Spacer()
                        Text("Choose card design")
                            .font(.custom("Chillax", size: 18))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "chevron.foreward") // Replace with your icon
                            .foregroundColor(.white)
                    }
                    .padding() // Apply padding inside the HStack to ensure space around text and icon
                    .frame(width: 250, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardColorDark))
                }
                .padding(.bottom, 20)
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
    WriteThankMeCardView()
}
