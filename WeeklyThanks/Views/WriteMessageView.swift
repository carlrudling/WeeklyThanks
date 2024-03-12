
import SwiftUI

struct WriteMessageView: View {
      @State private var message: String = ""
      @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
      @State private var showingMessageComposer = false
      @State private var recipients = [""]
      @State private var bodyImage: UIImage?
      @State private var keyboardIsShown: Bool = false

      @EnvironmentObject var userViewModel: UserViewModel
      @EnvironmentObject var receiverViewModel: ReceiverViewModel
    
    
    
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
                ThankYouCardView(scaleFactor: 0.9, message: message, senderName: receiverViewModel.userNickname ?? userViewModel.name, receiverName: receiverViewModel.name, cardNumber: userViewModel.count + 1, date: Date())
                    .padding(.bottom, 15)
                
                
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
                    
                    Text("/ Carl")
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 14))
                    Rectangle()
                        .frame(height: 1) // Make the rectangle thin, like a line
                        .foregroundColor(.white) // Set the line color
                        .frame(width: 50 )
                        .padding(.top, -10)
                }
                .padding(.top, -20)
                
                Spacer()
                
                
                Button(action: {
                    // Action for the button
                }) {
                    Text("Write another")
                        .font(.custom("Chillax", size: 18))
                        .foregroundColor(.gray)
                        .frame(width: 250, height: 40)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    
                }
                .padding(.bottom,15)
                
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
                        self.bodyImage = cardView.snapshot(with: customSize, scale: 3.0) // Use the custom size and adjust scale factor as needed

                        self.recipients = [self.receiverViewModel.telephoneNumber]
                        self.showingMessageComposer = true
                    
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
        }
//        .sheet(isPresented: $showingMessageComposer) {
//            
//            if let bodyImage {
//                MessageComposerView(recipients: recipients, bodyImage: bodyImage) { messageSent in
//                    // Handle the message sent confirmation or error
//                }
//            }
//        }
        .sheet(isPresented: $showingMessageComposer) {
            if let unwrappedImage = bodyImage {
                MessageComposerView(recipients: recipients, bodyImage: unwrappedImage) { messageSent in
                    if messageSent {
                        // The message was sent successfully
                        print("Message was sent successfully.")
                        self.userViewModel.incrementMessageCount() // Increment the user's message count

                    } else {
                        // The message was not sent (cancelled or failed)
                        print("Message was not sent.")
                        // Here, you might want to handle the case of a failed message sending attempt.
                        // This could include showing an error message to the user or logging the failure.
                    }
                }
            }
        }


        
    }
    
}
/*
// Ensure you have this extension correctly implemented in your project
extension View {
    func snapshot(with size: CGSize? = nil, highQuality: Bool = true) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        // Determine the target size: use provided size or intrinsic content size if nil
        let targetSize = size ?? controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        // Setup the window to render the controller's view
        let window = UIWindow(frame: CGRect(origin: .zero, size: targetSize))
        window.rootViewController = controller
        window.isHidden = false

        // Configure the renderer with high quality if requested
        let scale = highQuality ? UIScreen.main.scale * 3 : UIScreen.main.scale // Adjust multiplier for higher quality
        let options = UIGraphicsImageRendererFormat()
        options.scale = scale

        let renderer = UIGraphicsImageRenderer(size: targetSize, format: options)
        return renderer.image { _ in
            view?.drawHierarchy(in: CGRect(origin: .zero, size: targetSize), afterScreenUpdates: true)
        }
    }
}

*/

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


/*
extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
*/
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
