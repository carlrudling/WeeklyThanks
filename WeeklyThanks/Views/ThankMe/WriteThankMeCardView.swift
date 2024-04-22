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
                
                
                Text("Grow self-appreciation")
                               .foregroundColor(.white)
                               .font(.custom("Chillax", size: 18))
                           
                           if let profileImage = userViewModel.profileImage {
                               ZStack{
                                   Image(systemName: "circle")
                                       .resizable()
                                       .scaledToFit()
                                       .frame(width: 140, height: 140)
                                       .foregroundColor(.white)
                                   Image(uiImage: profileImage)
                                       .resizable()
                                       .scaledToFit()
                                       .frame(width: 130, height: 130)
                                       .clipShape(Circle()) // Display the selected image as a circle
                               }
                               .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 4)
                           } else {
                               Image(systemName: "photo.circle.fill")
                                   .resizable()
                                   .scaledToFit()
                                   .frame(width: 130, height: 130)
                                   .foregroundColor(.white.opacity(1.0))
                           }
                Text("You're also talking to this kid,\ntry being extra kind ;)")
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 12))
                    .multilineTextAlignment(.center)
                Spacer()
                Spacer()

                Text("Anything you want to thank yourself for? ")
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 16))
                    .padding(.top, 20)

               
                
                
                VStack {
                    ZStack(alignment: .topLeading) {
                        if thankYouCardViewModel.message.isEmpty {
                            Text("Ex: Worked towards your goals, done something kind, taken care of yourself?")
                                .font(.custom("Chillax", size: 14))
                                .foregroundColor(Color(UIColor.placeholderText))
                                .padding(4)
                            
                        }
                        TextEditor(text: $thankYouCardViewModel.message)
                            .onChange(of: thankYouCardViewModel.message) { newValue in
                                if newValue.count > 150 { // Limit to 150 characters
                                    thankYouCardViewModel.message = String(newValue.prefix(150))
                                }
                                //                            self.dynamicSize = calculateDynamicSize(for: thankYouCardViewModel.message)
//                                self.updateViewID = UUID()
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
                    
                    
                    Spacer()
                    
                    Button(action: {
                        coordinator.push(.chooseDesign)
                        
                        
                    }) {
                        HStack {
                            Image(systemName: "chevron.forward") // Replace with your icon
                                .foregroundColor(.clear)
                            Spacer()
                            Text("Choose card design")
                                .font(.custom("Chillax", size: 18))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.forward") // Replace with your icon
                                .foregroundColor(.white)
                        }
                        .padding() // Apply padding inside the HStack to ensure space around text and icon
                        .frame(width: 250, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundDarkBlue))
                    }
                    .padding(.bottom, 20)
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [.backgroundDarkBlue, .backgroundLightBlue]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { self.presentationMode.wrappedValue.dismiss(); thankYouCardViewModel.message = ""}) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.white)
                            .padding(12)
                    }
                }
            }
        }
    }
}

//#Preview {
//    WriteThankMeCardView()
//}
