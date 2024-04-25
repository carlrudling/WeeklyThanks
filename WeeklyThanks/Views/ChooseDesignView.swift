
import SwiftUI

struct ChooseDesignView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var thankYouCardViewModel : ThankYouCardViewModel
    @EnvironmentObject var receiverViewModel: ReceiverViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var coordinator: NavigationCoordinator
    
    @State private var showingMessageComposer = false
    @State private var showChangeCardView = false
    @State private var bodyImage: UIImage?
    @State private var showingEditReceiverView = false
    @State private var recipients = [""]

    @State private var presentedImage: IdentifiableImage?

    private var columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    @State private var updateViewID = UUID()
    @State private var dynamicSize: CGSize = CGSize(width: 360, height: 240) // Default size
    @State private var sizeForScreenshot: CGSize = CGSize(width: 360, height: 240)
    
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
            LinearGradient(gradient: Gradient(colors: [.backgroundLight, .backgroundDark]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                ThankYouCardView(scaleFactor: 0.9, message: thankYouCardViewModel.message, senderName: userViewModel.name, receiverName: receiverViewModel.name, cardNumber: userViewModel.count + 1, date: Date(), theme: thankYouCardViewModel.selectedTheme)
                    .id(updateViewID) // Force redraw
                    .frame(width: dynamicSize.width, height: dynamicSize.height)
                    .padding(.top, 10)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    ForEach(thankYouCardViewModel.themes, id: \.self) { theme in
                        ThankYouCardView(
                            scaleFactor: 0.4,
                            message: thankYouCardViewModel.message,
                            senderName: userViewModel.name,
                            receiverName: receiverViewModel.name,
                            cardNumber: userViewModel.count + 1,
                            date: Date(),
                            theme: theme
                            
                        )
                        .padding(.vertical, -70)
                        .onTapGesture {
                            // Set the selected theme when a card is tapped
                            thankYouCardViewModel.selectedTheme = theme
                            
                        }
                    }
                }
            }
            
            VStack{
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
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 2)

                    
                }
                .padding(.bottom, 20)
            }
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
                               count: Int64(self.userViewModel.count + 1), theme: thankYouCardViewModel.selectedTheme, sentToSelf: false,// Safely unwrapped Receiver
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
        .onAppear {
            refreshData()
        }
    }
    
}


extension View {
    func snapshot(with size: CGSize, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        let controller = UIHostingController(rootView: self.edgesIgnoringSafeArea(.all))
        controller.view.frame = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear // Set to clear to avoid unwanted backgrounds

        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        window.rootViewController = controller
        window.isHidden = true

        // Ensure the view is fully laid out
        controller.view.setNeedsLayout()
        controller.view.layoutIfNeeded()

        let rendererFormat = UIGraphicsImageRendererFormat.default()
        rendererFormat.opaque = false
        rendererFormat.scale = scale

        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)
        let image = renderer.image { context in
            // Simplified origin calculation for true centering
            let xOffset = (size.width - controller.view.bounds.width) / 2
            let yOffset = (size.height - controller.view.bounds.height) / 2
            let origin = CGPoint(x: xOffset, y: yOffset)

            // Draw the view hierarchy into the context at the calculated origin
            controller.view.drawHierarchy(in: CGRect(origin: origin, size: controller.view.bounds.size), afterScreenUpdates: true)
        }

        return image
    }
}


struct IdentifiableImage: Identifiable {
    let id = UUID() // Provide a unique ID
    var image: UIImage
}
