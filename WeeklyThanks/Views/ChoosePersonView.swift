import SwiftUI

struct ChoosePersonView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var receivers: [Receiver] = [] // Array to hold fetched receivers
    @EnvironmentObject var coordinator: NavigationCoordinator

    private var dataManager = DataManager.shared // Accessing the shared instance
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @State private var navigateToWriteMessage = false
    
    @State var navigateRemoveReceiverViev = false
    @State private var quoteOpacity = 0.0
    @State private var quoteOffset = 20.0
    
    var body: some View {
        VStack {
            Text("WeeklyThanks")
                .font(.custom("LeckerliOne-regular", size: 28))
                .padding(.top, 35)
                .foregroundColor(.white)
            
            if receiverViewModel.receivers.isEmpty {
                Text("No previous friends found.")
                    .padding()
                    .foregroundColor(.white)
                    .font(.custom("Chillax", size: 16))
            } else {
                ScrollView(showsIndicators: false) {
                    ForEach(receiverViewModel.receivers, id: \.self) { receiver in
                        Button(action: {
                            receiverViewModel.name = receiver.name ?? ""
                            receiverViewModel.telephoneNumber = receiver.telephoneNumber ?? ""
                            receiverViewModel.currentReceiverId = receiver.id
                            coordinator.push(.WriteMessage)
                        }) {
                            Text(receiver.name ?? "Unknown Receiver")
                                .font(.custom("Chillax", size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .opacity(quoteOpacity)
                                .offset(y: quoteOffset) // Adjust the value as needed to move the text up
                                .onAppear {
                                    // Start the animations when the view appears
                                    withAnimation(.easeOut(duration: 2)) {
                                        quoteOpacity = 1.0 // Fade in to full opacity
                                        quoteOffset = 0.0 // Move up to its original position
                                    }
                                }
                        }
                    }
                }
            } 
            
            Spacer()
            
            
            Button {
                coordinator.push(.manuallyOrContact)
            } label: {
                Text("Add new friend")
                    .font(.custom("Chillax", size: 18))
                    .foregroundColor(.gray)
                    .frame(width: 300, height: 50)
                    .background(RoundedRectangle(cornerRadius: 15).fill(Color.buttonColorLight))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)
                    .padding(.bottom, 40)
            }

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
        .navigationBarBackButtonHidden(true)
        .onAppear {
//            self.receivers = dataManager.fetchReceivers()
            self.receiverViewModel.receivers = dataManager.fetchReceivers()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { navigateRemoveReceiverViev = true }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
        }

        .sheet(isPresented: $navigateRemoveReceiverViev) {
            // Make sure to inject the necessary EnvironmentObjects or any other dependencies
            RemoveReceiverView(isPresented: $navigateRemoveReceiverViev)
        }
    }
}

struct ChoosePersonView_Previews: PreviewProvider {
    static var previews: some View {
        ChoosePersonView()
    }
}
