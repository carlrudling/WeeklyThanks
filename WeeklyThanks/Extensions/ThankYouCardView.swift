import SwiftUI

struct ThankYouCardView: View {
    let scaleFactor: CGFloat // 90% of the original size
    let message: String
    let senderName: String
    let receiverName: String
    let cardNumber: Int
    let date: Date

    // Computed property to calculate font size based on character count
    private var messageFontSize: CGFloat {
        let characterCount = message.count
        if characterCount > 100 {
            return 12 // Decrease font size to 12 if character count exceeds 100
        } else if characterCount > 50 {
            return 14 // Decrease font size to 14 if character count exceeds 50
        } else {
            return 16 // Default font size
        }
    }

    private var formattedDate: String {
           let formatter = DateFormatter()
           formatter.dateFormat = "MM/dd/yy" // Adjust the format as needed
           return formatter.string(from: date)
       }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.cardColorLight, .cardColorDark]), startPoint: .top, endPoint: .bottom)
                .frame(width: 360, height: 240)
                .cornerRadius(15)
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 4)

            VStack {
                HStack {
                    Spacer()
                    Text(formattedDate)
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 12))
                }

                Spacer()

                VStack{
                    Text("To \(receiverName)")
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 12))
                    Spacer()
                    
                    DynamicSizeLabel(text: message, maxSize: 16, minSize: 12, textColor: UIColor.white, textAlignment: .center, customFontName: "YourCustomFontName", maxWidth: 200)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .font(.custom("Chillax", size: messageFontSize))
                        .padding()
                    Spacer()
                    Text("/ \(senderName)")
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 12))
                }

                Spacer()

                HStack {
                    Text("\(cardNumber)th")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                    Image(systemName: "heart.fill")
                        .foregroundColor(Color.buttonColorLight)
                        .font(.custom("Chillax", size: 14))
                    Spacer()
                    Text("WeeklyThanks")
                        .foregroundColor(.white)
                        .font(.custom("LeckerliOne-regular", size: 14))
                }
            }
            .padding()
            .frame(width: 360, height: 240)
        }
        .scaleEffect(scaleFactor)
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
extension View {
    func snapshot(afterScreenUpdates: Bool = true) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view
        let targetSize = CGSize(width: 360, height: 240) // Adjust based on your card size
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let window = UIWindow(frame: CGRect(origin: .zero, size: targetSize))
        window.rootViewController = controller
        window.isHidden = true

        // Layout and render the view
        controller.view.layoutIfNeeded()

        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: afterScreenUpdates)
        }
    }
}




struct ThankYouCardView_Previews: PreviewProvider {
    static var previews: some View {
        ThankYouCardView(scaleFactor: 0.9, message: "Your message here", senderName: "Carl", receiverName: "Dad", cardNumber: 5, date: Date())
    }
}
