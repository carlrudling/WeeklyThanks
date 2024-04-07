import SwiftUI
import UIKit

struct DynamicSizeLabel: UIViewRepresentable {
    var text: String
    var maxSize: CGFloat
    var textColor: UIColor
    var textAlignment: NSTextAlignment
    var customFontName: String
    var maxWidth: CGFloat

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5 // Adjust this as needed
        label.lineBreakMode = .byWordWrapping // Change to word wrapping
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.preferredMaxLayoutWidth = maxWidth
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
        uiView.font = UIFont(name: customFontName, size: maxSize) ?? UIFont.systemFont(ofSize: maxSize)
        uiView.textColor = textColor
        uiView.textAlignment = textAlignment
        // No need to adjust font size manually; adjustsFontSizeToFitWidth will handle it
    }
}
