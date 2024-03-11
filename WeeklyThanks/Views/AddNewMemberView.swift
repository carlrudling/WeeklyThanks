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
    @State private var navigateToWriteMessage = false // State to control navigation
    @State private var telephoneNumberString: String = "" // For binding to the TextField

    var body: some View {
        VStack{
            Text("Details of the person you want to thank.")
                .padding(.horizontal, 100)
                .multilineTextAlignment(.center)
                .font(.custom("Chillax", size: 16))
                .padding(.vertical, 80)
                .foregroundColor(.white)
            
            VStack{
             
                
                TextField("", text: $receiverViewModel.name)
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 14))

                Rectangle()
                    .frame(height: 1) // Make the rectangle thin, like a line
                    .foregroundColor(.white) // Set the line color
                    .frame(width: 150 )
                   
                
                
                // Optionally, use the input text somewhere
                Text("Name or nickname of the person")
                    .font(.custom("Chillax", size: 12))
                    .foregroundColor(.white)
                
                TextField("", text: $receiverViewModel.userNickname).font(.system(size: 14))
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 14))
                Rectangle()
                    .frame(height: 1) // Make the rectangle thin, like a line
                    .foregroundColor(.white) // Set the line color
                    .frame(width: 150 )
                
                
                // Optionally, use the input text somewhere
                Text("Your nickname to that person")
                    .font(.custom("Chillax", size: 12))
                    .foregroundColor(.white)
                
                TextField("", text: $telephoneNumberString).font(.system(size: 14))
                    .padding(.horizontal, 40)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 14))
                Rectangle()
                    .frame(height: 1) // Make the rectangle thin, like a line
                    .foregroundColor(.white) // Set the line color
                    .frame(width: 150 )
                // Optionally, use the input text somewhere
                Text("Telefonenumber")
                    .font(.custom("Chillax", size: 12))
                    .foregroundColor(.white)
                
            }
            Spacer()
            
            Button(action: {
                
                receiverViewModel.createReceiver(name: receiverViewModel.name, userNickname: receiverViewModel.userNickname, telephoneNumber: telephoneNumberString)
                    self.navigateToWriteMessage = true
                        }) {
                Text("Save")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorGreen))
            }
            .padding(.bottom, 30)
                           
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen
        .background(
            NavigationLink(destination: WriteMessageView(), isActive: $navigateToWriteMessage) {
                EmptyView()
            }
                .hidden() // Hide the navigation link itself
        )
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
