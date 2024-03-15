
import Foundation
import MessageUI
import SwiftUI

struct MessageComposerView: UIViewControllerRepresentable {
    var recipients: [String]?
    var body: String?
    var bodyImage: UIImage
    let completion: (_ messageSent: Bool) -> Void

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = context.coordinator
        composer.recipients = ["0707106032"]
        composer.body = body

        // Attach the image if available
        // Attach the image directly since it's no longer optional
        
        if let imageData = bodyImage.pngData() {
            composer.addAttachmentData(imageData, typeIdentifier: "public.png", filename: "capturedImage.png")
        }

        return composer
    }

    func updateUIViewController(_ uiViewController: MFMessageComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(completion: completion)
    }

    class Coordinator: NSObject, MFMessageComposeViewControllerDelegate {
        let completion: (_ messageSent: Bool) -> Void

        init(completion: @escaping (_ messageSent: Bool) -> Void) {
            self.completion = completion
        }

        func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
            controller.dismiss(animated: true) {
                DispatchQueue.main.async { // Ensure the completion handler is executed on the main thread
                    // Check the result to see if the message was sent
                    if result == .sent {
                        print("Message was sent successfully.")
                        self.completion(true) // Call the completion handler with true to indicate success
                    } else {
                        print("Message was not sent.")
                        self.completion(false) // Call the completion handler with false to indicate failure
                    }
                }
            }
        }
    }


}

