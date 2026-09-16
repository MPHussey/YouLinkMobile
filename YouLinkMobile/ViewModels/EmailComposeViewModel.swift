//
//  EmailComposeViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI
import UniformTypeIdentifiers

//what the compose screen is doing
enum ComposeMode {
    case new
    case reply(Email)
}

class EmailComposeViewModel: ObservableObject {
    let fromAddress: String
    let mode: ComposeMode

    @Published var to = ""
    @Published var subject = ""
    @Published var messageBody = ""
    @Published var attachments: [MultipartFile] = []

    @Published var isSending = false
    @Published var errorMessage: String?
    @Published var didSend = false

    private let service = EmailService.shared

    init(fromAddress: String, mode: ComposeMode = .new) {
        self.fromAddress = fromAddress
        self.mode = mode

        //prefill recipient + subject when replying
        if case .reply(let original) = mode {
            to = original.fromEmail
            subject = Self.replySubject(original.subject)
        }
    }

    var screenTitle: String {
        switch mode {
        case .new:   return "New Mail"
        case .reply: return "Reply"
        }
    }

    //"This is test" -> "Re: This is test" (avoid stacking "Re:")
    static func replySubject(_ subject: String) -> String {
        subject.lowercased().hasPrefix("re:") ? subject : "Re: \(subject)"
    }

    //read picked files into memory so they can be uploaded
    func addAttachments(urls: [URL]) {
        for url in urls {
            let didAccess = url.startAccessingSecurityScopedResource()
            defer { if didAccess { url.stopAccessingSecurityScopedResource() } }

            guard let data = try? Data(contentsOf: url) else { continue }
            let mimeType = UTType(filenameExtension: url.pathExtension)?
                .preferredMIMEType ?? "application/octet-stream"

            attachments.append(
                MultipartFile(
                    fileName: url.lastPathComponent,
                    mimeType: mimeType,
                    data: data
                )
            )
        }
    }

    func removeAttachment(_ file: MultipartFile) {
        attachments.removeAll { $0.id == file.id }
    }

    func send() {
        let trimmedTo = to.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTo.isEmpty else {
            errorMessage = "Please enter a recipient."
            return
        }
        guard let creds = AuthService.shared.storedCredentials else {
            errorMessage = "Missing credentials. Please sign in again."
            return
        }

        isSending = true
        errorMessage = nil

        switch mode {
        case .new:
            service.sendEmail(
                staffNumber: creds.staffNumber,
                password: creds.password,
                to: trimmedTo,
                subject: subject,
                body: messageBody,
                isHtml: false,
                attachments: attachments,
                completion: handleResult
            )
        case .reply(let original):
            print("""
            📤 REPLY -> to: \(trimmedTo)
               subject: \(subject)
               originalMessageId: \(original.messageId)
               originalSubject: \(original.subject)
               body: \(messageBody)
               attachments: \(attachments.count)
            """)
            service.replyEmail(
                staffNumber: creds.staffNumber,
                password: creds.password,
                originalMessageId: original.messageId,
                originalSubject: original.subject,
                to: trimmedTo,
                subject: subject,
                body: messageBody,
                isHtml: false,
                attachments: attachments,
                completion: handleResult
            )
        }
    }

    private func handleResult(_ result: Result<EmailActionResponse, Error>) {
        DispatchQueue.main.async {
            self.isSending = false
            switch result {
            case .success(let response):
                print("✅ Server response -> success: \(response.success), message: \(response.message)")
                if response.success {
                    self.didSend = true
                } else {
                    self.errorMessage = response.message.isEmpty
                        ? "Could not send the email."
                        : response.message
                }
            case .failure(let error):
                print("❌ Send/Reply failed -> \(error)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
