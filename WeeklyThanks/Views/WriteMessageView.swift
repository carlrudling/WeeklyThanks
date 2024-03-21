
import SwiftUI

struct WriteMessageView: View {
      @State private var message: String = ""
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
            let words = message.split { $0.isWhitespace }.map(String.init)
            if words.count > wordLimit {
                message = words.prefix(wordLimit).joined(separator: " ")
            }
        }
    
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
            VStack {
                
                if receiverViewModel.userNickname != "" {
                    ThankYouCardView(scaleFactor: 0.9, message: message, senderName: receiverViewModel.userNickname, receiverName: receiverViewModel.name, cardNumber: userViewModel.count + 1, date: Date())
                        .padding(.bottom, 15)
                    
                } else {
                    ThankYouCardView(scaleFactor: 0.9, message: message, senderName: userViewModel.name, receiverName: receiverViewModel.name, cardNumber: userViewModel.count + 1, date: Date())
                        .padding(.bottom, 15)
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
                    
                    TextEditorBackground()
                        .frame(height: 150) // Ensure this matches the TextEditor frame size for alignment
                        .padding(.top, 10)
                    TextEditor(text: $message)
                        .onChange(of: message) { newValue in
                            if newValue.count > 150 { // Limit to 150 characters
                                message = String(newValue.prefix(150))
                            }
                        }
                        .font(.custom("Chillax", size: 16)) // Adjust font size dynamically
                        .background(Color.clear)
                        .foregroundColor(.white)
                        .scrollContentBackground(.hidden)
                        .lineSpacing(6)
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
                    Text("Max 150 characters")
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 14))
                        .padding(.trailing, 20)
                        .padding(.top, -60)
                }
                
                VStack{
                    if receiverViewModel.userNickname != "" {
                        Text("/ \(receiverViewModel.userNickname)")
                            .foregroundColor(.white)
                            .font(.custom("Chillax", size: 14))
                    } else {
                        Text("/ \(userViewModel.name)")
                            .foregroundColor(.white)
                            .font(.custom("Chillax", size: 14))
                    }
                    Rectangle()
                        .frame(height: 1) // Make the rectangle thin, like a line
                        .foregroundColor(.white) // Set the line color
                        .frame(width: 50 )
                        .padding(.top, -10)
                }
                .padding(.top, -20)
                
                Spacer()
                

                
                Button(action: {
                    
                    // Define the custom size based on the scaled dimensions of the ThankYouCardView
                    let customSize = CGSize(width: 360 * 1.2, height: 240 * 1.2) // Adjust based on your actual scale factor and card size

                        // Preparing the ThankYouCardView for snapshot
                        let cardView = ThankYouCardView(
                            scaleFactor: 1.0, // Use the appropriate scale factor for UI display
                            message: self.message,
                            senderName: self.userViewModel.name,
                            receiverName: self.receiverViewModel.name,
                            cardNumber: self.userViewModel.count + 1,
                            date: Date()
                        )

                    // Capturing a high-quality snapshot of the card view
                    let image = cardView.snapshot(with: customSize, scale: 3.0) // Use the custom size and adjust scale factor as needed
                        self.presentedImage = IdentifiableImage(image: image)
                        print("Image is ready. Size: \(image.size.width) x \(image.size.height), Scale: \(image.scale)")
                        
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

    .sheet(item: $presentedImage, onDismiss: {
            print("Sheet dismissed.")
        }) { identifiableImage in
            MessageComposerView(recipients: recipients, bodyImage: identifiableImage.image) { messageSent in
                if messageSent {
                    print("Message was sent successfully.")
                    self.userViewModel.incrementMessageCount()
                    if let user = self.userViewModel.currentUser, let receiver = self.receiverViewModel.currentReceiver {
                                 thankYouCardViewModel.createThankYouCard(
                                     message: self.message,
                                     writeDate: Date(), // Current date
                                     user: user, // Safely unwrapped User
                                     receiver: receiver,
                                     count: Int64(self.userViewModel.count + 1),// Safely unwrapped Receiver
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
                                 coordinator.push(.afterSentCard)
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

        .sheet(isPresented: $showingEditReceiverView) {
            // Make sure to inject the necessary EnvironmentObjects or any other dependencies
            EditReceiverView().environmentObject(receiverViewModel)
        }


        
    }
    
}

extension View {
    func snapshot(with size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        view?.bounds = CGRect(origin: .zero, size: size)
        view?.backgroundColor = .clear

        // Make sure the window is large enough to host your view
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = controller
        window.isHidden = true

        // Rendering the controller's view into an image
        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = false
        rendererFormat.scale = scale

        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        return renderer.image { _ in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: size), afterScreenUpdates: true)
        }
    }
}



struct WriteMessageView_Previews: PreviewProvider {
    static var previews: some View {
        WriteMessageView()
            .background(Color.black) // Set a contrasting background to see the white lines
    }
}


struct TextEditorBackground: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let lineSpacing: CGFloat = 28 // Adjust line spacing to your preference
                let lines = Int(geometry.size.height / lineSpacing)
                
                for i in 0..<lines {
                    let y = CGFloat(i) * lineSpacing
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.white.opacity(0.5), lineWidth: 1) // Set line color and opacity
        }
    }
}


struct IdentifiableImage: Identifiable {
    let id = UUID() // Provide a unique ID
    var image: UIImage
}
