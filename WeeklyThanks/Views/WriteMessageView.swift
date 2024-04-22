
import SwiftUI

struct WriteMessageView: View {
      @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
      @State private var showingMessageComposer = false
      @State private var recipients = [""]
      @State private var bodyImage: UIImage?
      @State private var keyboardIsShown: Bool = false
      @State private var presentedImage: IdentifiableImage?
      @EnvironmentObject var userViewModel: UserViewModel
      @EnvironmentObject var receiverViewModel: ReceiverViewModel
      @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel
      @EnvironmentObject var coordinator: NavigationCoordinator

      @State private var showingEditReceiverView = false

    
    
    // Function to trim userInput to 30 words
        func trimText(to wordLimit: Int) {
            let words = thankYouCardViewModel.message.split { $0.isWhitespace }.map(String.init)
            if words.count > wordLimit {
                thankYouCardViewModel.message = words.prefix(wordLimit).joined(separator: " ")
            }
        }
    
    @State private var dynamicSize: CGSize = CGSize(width: 360, height: 240) // Default size
    @State private var sizeForScreenshot: CGSize = CGSize(width: 360, height: 240)
    @State private var updateViewID = UUID()

    private func calculateDynamicSize(for message: String) -> CGSize {
        // Your dynamic size calculation logic based on the message
        // This is just a placeholder logic
        let lines = CGFloat((message.count / 50) + 1)
        let height = max(240, lines * 20) // Calculate dynamically
        let width = max(360, lines * 20)

        return CGSize(width: width, height: height)
    }
    
    private func calculateDynamicSizeForSnapshot(for message: String) -> CGSize {
        // Your dynamic size calculation logic based on the message
        // This is just a placeholder logic
        let lines = CGFloat((message.count / 50) + 1)
        let height = 240 + 24 + lines * 10 // Calculate dynamically based on the number of lines
        let width = 360 + 36 + lines * 10 // Assuming you want to increase width in a similar fashion
        let size = CGSize(width: width, height: height)
           print("Calculated Dynamic Size for Snapshot: \(size)")
        
           return size
    }
    
  
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
 
    private func refreshData() {
        self.recipients = [self.receiverViewModel.telephoneNumber]
        
        // Check if there's a currentReceiverId before attempting to set the current receiver
        if let currentReceiverId = receiverViewModel.currentReceiverId {
            receiverViewModel.setCurrentReceiver(by: currentReceiverId)
        } else {
            print("Current Receiver ID is nil")
        }
        
        if userViewModel.currentUser == nil {
            print("User is nil")
        }
        if receiverViewModel.currentReceiver == nil {
            print("Receiver is nil")
        }
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
            VStack {
                ThankYouCardView(scaleFactor: 0.9, message: thankYouCardViewModel.message, senderName: userViewModel.name, receiverName: receiverViewModel.name, cardNumber: userViewModel.count + 1, date: Date(), theme: thankYouCardViewModel.selectedTheme)
                    .id(updateViewID) // Force redraw
                    .frame(width: dynamicSize.width, height: dynamicSize.height)
                    .padding(.vertical, 10)
                
                
                
                
                
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
                    
                    coordinator.push(.chooseSendDesign)
                    
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
        .frame(maxWidth: .infinity, maxHeight: .infinity) // Expand VStack to fill the screen
      
        .background(
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all) // Apply edgesIgnoringSafeArea to the background
        )
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { self.presentationMode.wrappedValue.dismiss(); thankYouCardViewModel.message = "" }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingEditReceiverView = true }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .padding(12)
                }
            }
        }
        .onAppear {
            refreshData()
        }
        
        .sheet(isPresented: $showingEditReceiverView, onDismiss: {
            // Actions to perform after the sheet is dismissed
            // For example, refresh data in your receiverViewModel or perform UI updates
            refreshData() // Assuming you have a method like this to refresh data
        }) {
            // Make sure to inject the necessary EnvironmentObjects or any other dependencies
            EditReceiverView().environmentObject(receiverViewModel)
        }
        



        
    }
    
}



struct WriteMessageView_Previews: PreviewProvider {
    static var previews: some View {
        WriteMessageView()
            .background(Color.black) // Set a contrasting background to see the white lines
    }
}



