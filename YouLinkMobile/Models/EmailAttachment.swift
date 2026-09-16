//
//  EmailAttachment.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import Foundation

struct EmailAttachment: Identifiable, Decodable {
    var id: String { attachmentId }
    let attachmentId: String
    let fileName: String
    let contentType: String
    let sizeBytes: Int
}

extension EmailAttachment {
    //human readable size -> "172692" => "168 KB"
    var displaySize: String {
        ByteCountFormatter.string(
            fromByteCount: Int64(sizeBytes),
            countStyle: .file
        )
    }
}
