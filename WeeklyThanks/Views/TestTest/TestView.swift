

import SwiftUI

struct TestView: View {
     @State private var showingMsg = false
      @State private var phoneNumber: String = ""
      @State private var message: String = ""
      @State private var capture: UIImage?
      @Environment(\.colorScheme) var colorScheme

    var body: some View {
        
        
        VStack{
            
            HStack {
                      ZStack(alignment: .bottom) {
                          SnapshotView()
                          Button("Capture", action: {
                              capture = ImageRenderer(content: SnapshotView()).uiImage
                          })
                          .padding()
                      }
                      if let image = capture {
                          Image(uiImage: image)
                      } else {
                          Color.clear
                      }
                  }
            
            TextField(
                "Phonenumber",
                text: $phoneNumber
            )
            TextField(
                "message",
                text: $message
            )
            
            Button("Show Messages") {
                self.showingMsg = true
            }
        }
        .sheet(isPresented: $showingMsg) {
                        MessageView(recipients: [phoneNumber],
                                    body: message,
                                    bodyImage: capture) { messageSent in
                            print("MessageView with message sent? \(messageSent)")
                        }
        }
    }
}

