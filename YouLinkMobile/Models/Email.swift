//
//  Email.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import Foundation

struct Email: Identifiable, Decodable {
    var id: String { messageId }
    let messageId: String
    let subject: String
    let fromName: String
    let fromEmail: String
    let date: String
    let bodyPreview: String
    let textBody: String
    let htmlBody: String
    var isRead: Bool
    let hasAttachments: Bool
}

extension Email {
    //clean text for the list row -> strips CSS/VML noise from the preview,
    //falling back to the html body when the preview is empty
    var previewText: String {
        let cleaned = Email.cleanText(bodyPreview)
        if !cleaned.isEmpty { return cleaned }
        return Email.cleanText(htmlBody)
    }

    //removes style/script blocks, css/vml rule blocks, html tags and entities
    static func cleanText(_ raw: String) -> String {
        var text = raw

        //drop <style>…</style> and <script>…</script> blocks
        text = text.replacingOccurrences(
            of: #"(?is)<(style|script)[^>]*>.*?</\1>"#,
            with: " ",
            options: .regularExpression
        )
        //drop html / conditional comments
        text = text.replacingOccurrences(
            of: #"(?s)<!--.*?-->"#,
            with: " ",
            options: .regularExpression
        )
        //drop css / vml rule blocks -> "selector { … }"
        text = text.replacingOccurrences(
            of: #"[^{}<>]*\{[^{}]*\}"#,
            with: " ",
            options: .regularExpression
        )
        //drop remaining html tags
        text = text.replacingOccurrences(
            of: #"<[^>]+>"#,
            with: " ",
            options: .regularExpression
        )
        //decode the common html entities
        let entities = [
            "&nbsp;": " ", "&amp;": "&", "&lt;": "<",
            "&gt;": ">", "&quot;": "\"", "&#39;": "'", "&apos;": "'"
        ]
        for (entity, value) in entities {
            text = text.replacingOccurrences(of: entity, with: value)
        }
        //collapse whitespace
        text = text.replacingOccurrences(
            of: #"\s+"#,
            with: " ",
            options: .regularExpression
        )
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    //initials taken from the sender name -> "Airline Insight" => "AI"
    var senderInitials: String {
        let parts = fromName
            .split(separator: " ")
            .filter { !$0.isEmpty }

        let letters = parts.prefix(2).compactMap { $0.first }
        let initials = String(letters).uppercased()
        return initials.isEmpty ? "?" : initials
    }

    //display time for the row -> "2026-06-07T10:21:21+05:30" => "10.21am"
    var displayTime: String {
        let inputFormatter = ISO8601DateFormatter()
        inputFormatter.formatOptions = [.withInternetDateTime]

        guard let parsedDate = inputFormatter.date(from: date) else {
            return ""
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h.mma"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.amSymbol = "am"
        outputFormatter.pmSymbol = "pm"
        return outputFormatter.string(from: parsedDate)
    }
}
