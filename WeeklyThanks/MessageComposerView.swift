

import Foundation
import MessageUI
import SwiftUI
/*
struct MessageComposerView: UIViewControllerRepresentable {
    var recipients: [String]?
    var body: String?
    var bodyImage: UIImage? // The image you want to send
    let completion: (_ messageSent: Bool) -> Void

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = context.coordinator
        composer.recipients = recipients
        composer.body = body

        // Attach the image if available
        if let image = bodyImage, let imageData = image.jpegData(compressionQuality: 1.0) {
            composer.addAttachmentData(imageData, typeIdentifier: "public.jpeg", filename: "capturedImage.jpg")
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
            controller.dismiss(animated: true, completion: nil)
            completion(result == .sent)
        }
    }
}
*/

struct MessageComposerView: UIViewControllerRepresentable {
    var recipients: [String]?
    var body: String?
    var bodyImage: UIImage? // The image you want to send
    let completion: (_ messageSent: Bool) -> Void

    func makeUIViewController(context: Context) -> MFMessageComposeViewController {
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = context.coordinator
        composer.recipients = recipients
        composer.body = body

        // Attach the image if available
        if let image = bodyImage, let imageData = image.jpegData(compressionQuality: 1.0) {
            composer.addAttachmentData(imageData, typeIdentifier: "public.jpeg", filename: "capturedImage.jpg")
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
            controller.dismiss(animated: true, completion: nil)
            completion(result == .sent)
        }
    }
}
