import SwiftUI
import UIKit

struct DynamicSizeLabel: UIViewRepresentable {
    var text: String
    var maxSize: CGFloat
    var minSize: CGFloat
    var textColor: UIColor
    var textAlignment: NSTextAlignment
    var customFontName: String
    var maxWidth: CGFloat // Add a variable for maximum width

    init(text: String, maxSize: CGFloat, minSize: CGFloat = 12, textColor: UIColor = .black, textAlignment: NSTextAlignment = .left, customFontName: String, maxWidth: CGFloat) {
        self.text = text
        self.maxSize = maxSize
        self.minSize = minSize
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.customFontName = customFontName
        self.maxWidth = maxWidth // Initialize maxWidth
    }

    func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.preferredMaxLayoutWidth = maxWidth // Set the preferred max width
        return label
    }

    func updateUIView(_ uiView: UILabel, context: Context) {
        uiView.text = text
        uiView.textColor = textColor
        uiView.textAlignment = textAlignment
        uiView.preferredMaxLayoutWidth = maxWidth // Ensure this is updated if maxWidth changes
        adjustFontSize(for: uiView)
    }
    
    private func adjustFontSize(for label: UILabel) {
        let fontSize = calculateFontSize(for: label)
        label.font = UIFont(name: customFontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
    }
    
    private func calculateFontSize(for label: UILabel) -> CGFloat {
        // Adjust your font size calculation logic here
        return min(maxSize, max(minSize, maxSize - CGFloat(text.count / 50))) // Simplified logic
    }
}
