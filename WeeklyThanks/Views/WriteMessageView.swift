
import SwiftUI

struct WriteMessageView: View {
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
        let height = max(240, lines * 100) // Calculate dynamically
        let width = max(360, lines * 20)

        return CGSize(width: width, height: height)
    }
    
    private func calculateDynamicSizeForSnapshot(for message: String) -> CGSize {
        // Your dynamic size calculation logic based on the message
        // This is just a placeholder logic
        let lines = CGFloat((message.count / 50) + 1)
        let height = 240 + lines * 20 // Calculate dynamically based on the number of lines
        let width = 360 + lines * 20 // Assuming you want to increase width in a similar fashion
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
                 
                    Button {
                        self.showChangeCardView = true
                    } label: {
                        ZStack{
                            ThankYouCardView(scaleFactor: 0.9, message: thankYouCardViewModel.message, senderName: userViewModel.name, receiverName: receiverViewModel.name, cardNumber: userViewModel.count + 1, date: Date(), theme: thankYouCardViewModel.selectedTheme)
                                .id(updateViewID) // Force redraw
                                .frame(width: dynamicSize.width, height: dynamicSize.height)
                            
                            Text("Press to change card")
                                .foregroundColor(.white)
                                .font(.custom("Chillax", size: 14))
                                .opacity(thankYouCardViewModel.message == "" ? 1.0 : 0.0)
                        }
                    }
                
                
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
                    
                    // Update dynamic size based on the current message
                    self.sizeForScreenshot = self.calculateDynamicSizeForSnapshot(for: self.thankYouCardViewModel.message)
                    print("Size for Screenshot Before Capturing: \(self.sizeForScreenshot)")

                    // Prepare ThankYouCardView with the current state
                          let cardView = ThankYouCardView(
                              scaleFactor: 1.0,
                              message: self.thankYouCardViewModel.message,
                              senderName: self.userViewModel.name,
                              receiverName: self.receiverViewModel.name,
                              cardNumber: self.userViewModel.count + 1,
                              date: Date(), theme: thankYouCardViewModel.selectedTheme
                          )

                    
                          // Capture the snapshot using the updated dynamic size
                          let image = cardView.snapshot(with: self.sizeForScreenshot, scale: UIScreen.main.scale)
                          self.presentedImage = IdentifiableImage(image: image)
                    print("Snapshot Captured with Size: \(image.size), Scale: \(image.scale)")

                          print("Snapshot captured with updated size: Width: \(self.sizeForScreenshot.width), Height: \(self.sizeForScreenshot.height)")
                      

                }) {
                    HStack {
                        Image(systemName: "paperplane") // Replace with your icon
                            .foregroundColor(.clear)
                        Spacer()
                        Text("Send")
                            .font(.custom("Chillax", size: 18))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "paperplane") // Replace with your icon
                            .foregroundColor(.white)
                    }
                    .padding() // Apply padding inside the HStack to ensure space around text and icon
                    .frame(width: 250, height: 40)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.cardColorDark))
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
                Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
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

    .sheet(item: $presentedImage, onDismiss: {
            print("Sheet dismissed.")
        }) { identifiableImage in
            MessageComposerView(recipients: recipients, bodyImage: identifiableImage.image) { messageSent in
                if messageSent {
                    print("Message was sent successfully.")
                    if let user = self.userViewModel.currentUser, let receiver = self.receiverViewModel.currentReceiver {
                                 thankYouCardViewModel.createThankYouCard(
                                    message: self.thankYouCardViewModel.message,
                                     writeDate: Date(), // Current date
                                     user: user, // Safely unwrapped User
                                     receiver: receiver,
                                    count: Int64(self.userViewModel.count + 1), theme: thankYouCardViewModel.selectedTheme,// Safely unwrapped Receiver
                                     completion: { success in
                                         // Handle success or failure
                                         if success {
                                             print("Card saved successfully")
                                             // Perform additional actions, like navigating away or showing a success message
                                        
                                         } else {
                                             print("Failed to save the card")
                                             // Handle failure, such as showing an error message
                                         }
                                     }
                                 )
                                self.userViewModel.incrementMessageCount()
                                self.userViewModel.incrementWeeklySentCount()
                                self.userViewModel.updateLastSentCardDate()
                                 coordinator.push(.afterSentCard)
                                self.thankYouCardViewModel.message = ""
                             } else {
                                 // Handle the case where user or receiver is nil
                                 print("User or Receiver is nil, cannot save the card.")
                             }
                         } else {
                             print("Message was not sent.")
                         }
                         // Reset the presentedImage to dismiss the sheet
                         self.presentedImage = nil
                     }
                 }

        .sheet(isPresented: $showingEditReceiverView, onDismiss: {
            // Actions to perform after the sheet is dismissed
            // For example, refresh data in your receiverViewModel or perform UI updates
            refreshData() // Assuming you have a method like this to refresh data
        }) {
            // Make sure to inject the necessary EnvironmentObjects or any other dependencies
            EditReceiverView().environmentObject(receiverViewModel)
        }
        
        .sheet(isPresented: $showChangeCardView) {
            // Make sure to inject the necessary EnvironmentObjects or any other dependencies
            ChangeCardThemeView()
        }



        
    }
    
}

//extension View {
//    func snapshot(with size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
//        let controller = UIHostingController(rootView: self)
//        let view = controller.view
//
//        view?.bounds = CGRect(origin: .zero, size: size)
//        view?.backgroundColor = .red
//
//        // Make sure the window is large enough to host your view
//        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
//        window.rootViewController = controller
//        window.isHidden = true
//
//        // Rendering the controller's view into an image
//        let rendererFormat = UIGraphicsImageRendererFormat.default()
//        rendererFormat.opaque = false
//        rendererFormat.scale = scale
//
//        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
//        return renderer.image { _ in
//            view?.drawHierarchy(in: CGRect(origin: CGPoint(x: 0, y: -20), size: size), afterScreenUpdates: true)
//        }
//    }
//}

extension View {
    func snapshot(with size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.frame = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear

        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = controller
        window.isHidden = true

        // Try to force the layout of all subviews immediately
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()
        
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = false
        rendererFormat.scale = scale

        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        let image = renderer.image { _ in
            let contextSize = controller.view.bounds.size
            // Adjust the y-origin if necessary
            let contextRect = CGRect(x: 0, y: -20, width: contextSize.width, height: contextSize.height + 20)
            controller.view.drawHierarchy(in: contextRect, afterScreenUpdates: true)
        }

        return image
    }
}




struct WriteMessageView_Previews: PreviewProvider {
    static var previews: some View {
        WriteMessageView()
            .background(Color.black) // Set a contrasting background to see the white lines
    }
}


struct IdentifiableImage: Identifiable {
    let id = UUID() // Provide a unique ID
    var image: UIImage
}
