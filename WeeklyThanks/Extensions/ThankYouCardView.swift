import SwiftUI

struct ThankYouCardView: View {
    let scaleFactor: CGFloat // 90% of the original size
    let message: String
    let senderName: String
    let receiverName: String
    let cardNumber: Int
    let date: Date
    let theme: String

    
    // Computed property to decide the background based on theme
    private var themeBackground: some View {
        switch theme {
        case "normal":
            return AnyView(LinearGradient(gradient: Gradient(colors: [.cardColorLight, .cardColorDark]), startPoint: .top, endPoint: .bottom))
        case "lotus":
            // Ensure "starNight" is the exact name of your image asset
            return AnyView(Image("lotus").resizable().scaledToFill())
        case "greenFlowers":
            // Ensure "starNight" is the exact name of your image asset
            return AnyView(Image("greenFlowers").resizable().scaledToFill())
        case "redHearts":
            // Ensure "starNight" is the exact name of your image asset
            return AnyView(Image("redHearts").resizable().scaledToFill())
        case "lotusStones":
            // Ensure "starNight" is the exact name of your image asset
            return AnyView(Image("lotusStones").resizable().scaledToFill())
        case "omSymbol":
            // Ensure "starNight" is the exact name of your image asset
            return AnyView(Image("omSymbol").resizable().scaledToFill())

        default:
            // Default background if no matching theme is found
            return AnyView(LinearGradient(gradient: Gradient(colors: [.cardColorLight, .cardColorDark]), startPoint: .top, endPoint: .bottom))
        }
    }

    
    
    // Placeholder for dynamic size calculation
    private var dynamicSize: CGSize {
        // Base dimensions for the card
        let baseWidth: CGFloat = 360
        let baseHeight: CGFloat = 240
        let extraHeightPerLine: CGFloat = 10
        let extraWidthPerLine: CGFloat = 10
        
        // Estimate lines based on message length. This is simplistic; adjust based on your content and font size
        
        let estimatedLines = CGFloat((message.count / 50) + 1) // Example: assuming roughly 50 characters per line
        let dynamicHeight = baseHeight + (estimatedLines * extraHeightPerLine)
        
        let dynamicWidth = baseWidth + (estimatedLines * extraWidthPerLine)
        
        return CGSize(width: dynamicWidth, height: dynamicHeight)
    }

    private var formattedDate: String {
           let formatter = DateFormatter()
           formatter.dateFormat = "MM/dd/yy" // Adjust the format as needed
           return formatter.string(from: date)
       }
    
    private func ordinalSuffix(for cardNumber: Int) -> String {
        if cardNumber == 1 {
            return "st"
        }
        if cardNumber == 2 {
            return "nd"
        }
        if cardNumber == 3 {
            return "rd"
        } else {
            return "th"
        }
    }
    
    
    var body: some View {
        ZStack {
                themeBackground
                       .frame(width: dynamicSize.width, height: dynamicSize.height)
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
                    
                    DynamicSizeLabel(
                                     text: message,
                                     maxSize: 16, // Adjust as needed
                                     textColor: UIColor.white,
                                     textAlignment: .center,
                                     customFontName: "Chillax",
                                     maxWidth: 300 // Adjust this based on the card's width or desired text width
                                 )

                    Spacer()
                    Text("/ \(senderName)")
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 12))
                }

                Spacer()

                HStack {
                    Text("\(cardNumber)\(ordinalSuffix(for: cardNumber))")
                        .foregroundColor(.white)
                        .font(.custom("Chillax", size: 14))
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
        }
        .frame(width: dynamicSize.width, height: dynamicSize.height)
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


struct ThankYouCardView_Previews: PreviewProvider {
    static var previews: some View {
        ThankYouCardView(scaleFactor: 0.9, message: "Your message here", senderName: "Carl", receiverName: "Dad", cardNumber: 5, date: Date(), theme: "normal")
    }
}
