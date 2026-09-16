//
//  HTMLBodyView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI
import UIKit

//renders an email html body as native, selectable text with tappable links
struct HTMLBodyView: UIViewRepresentable {
    let html: String
    var fontSize: CGFloat = 15

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false          // let SwiftUI size it via intrinsic height
        textView.backgroundColor = .clear
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainer.widthTracksTextView = true
        textView.adjustsFontForContentSizeCategory = true
        textView.dataDetectorTypes = []            // we rely on the html's own <a> links
        //grow vertically, but never push wider than the available space -> wraps text
        textView.setContentCompressionResistancePriority(.required, for: .vertical)
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        textView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return textView
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.attributedText = Self.attributedString(from: html, fontSize: fontSize)
    }

    //bound the text view to the width SwiftUI offers, then report the wrapped height
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        let width = proposal.width ?? UIScreen.main.bounds.width
        let fitted = uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
        return CGSize(width: width, height: ceil(fitted.height))
    }

    static func attributedString(from html: String, fontSize: CGFloat) -> NSAttributedString {
        guard
            let data = html.data(using: .utf8),
            let attributed = try? NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        else {
            return NSAttributedString(string: html)
        }

        let fullRange = NSRange(location: 0, length: attributed.length)

        //normalise the font while preserving bold / italic traits from the html
        attributed.enumerateAttribute(.font, in: fullRange) { value, range, _ in
            let traits = (value as? UIFont)?.fontDescriptor.symbolicTraits ?? []
            let baseDescriptor = UIFont.systemFont(ofSize: fontSize).fontDescriptor
            if let descriptor = baseDescriptor.withSymbolicTraits(traits) {
                attributed.addAttribute(.font, value: UIFont(descriptor: descriptor, size: fontSize), range: range)
            } else {
                attributed.addAttribute(.font, value: UIFont.systemFont(ofSize: fontSize), range: range)
            }
        }

        //make default black text adapt to light / dark mode, but leave links + coloured text alone
        attributed.enumerateAttribute(.foregroundColor, in: fullRange) { value, range, _ in
            if attributed.attribute(.link, at: range.location, effectiveRange: nil) != nil { return }
            let color = value as? UIColor
            if color == nil || color == .black {
                attributed.addAttribute(.foregroundColor, value: UIColor.label, range: range)
            }
        }

        return attributed
    }
}
