//
//  EmailService.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import Foundation

//generic { success, message } response used by mark-as-read, send, etc.
struct EmailActionResponse: Decodable {
    let success: Bool
    let message: String
}

class EmailService {
    static let shared = EmailService()
    private init() {}

    //fetch a folder of emails for the given user
    func getEmailList(
        staffNumber: String,
        password: String,
        folder: String = "inbox",
        count: Int = 20,
        offset: Int = 0,
        completion: @escaping (Result<[Email], Error>) -> Void
    ) {
        let payload: [String: Any] = [
            "staffNumber": staffNumber,
            "password": password,
            "folder": folder,
            "count": count,
            "offset": offset
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: payload)

        HTTPClient.shared.send(
            endpoint: .getEmailList,
            bodyData: bodyData,
            decodeTo: [Email].self,
            completion: completion
        )
    }

    //mark a single email as read
    func markAsRead(
        staffNumber: String,
        password: String,
        folder: String = "inbox",
        messageId: String,
        completion: @escaping (Result<EmailActionResponse, Error>) -> Void
    ) {
        let payload: [String: Any] = [
            "staffNumber": staffNumber,
            "password": password,
            "folder": folder,
            "messageId": messageId
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: payload)

        HTTPClient.shared.send(
            endpoint: .markAsRead,
            bodyData: bodyData,
            decodeTo: EmailActionResponse.self,
            completion: completion
        )
    }

    //list the attachments of a single email
    func getAttachments(
        staffNumber: String,
        password: String,
        folder: String = "inbox",
        messageId: String,
        completion: @escaping (Result<[EmailAttachment], Error>) -> Void
    ) {
        let payload: [String: Any] = [
            "staffNumber": staffNumber,
            "password": password,
            "folder": folder,
            "messageId": messageId
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: payload)

        HTTPClient.shared.send(
            endpoint: .emailAttachmentList,
            bodyData: bodyData,
            decodeTo: [EmailAttachment].self,
            completion: completion
        )
    }

    //download a single attachment's raw bytes
    func downloadAttachment(
        staffNumber: String,
        password: String,
        folder: String = "inbox",
        messageId: String,
        attachmentId: String,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        let payload: [String: Any] = [
            "staffNumber": staffNumber,
            "password": password,
            "folder": folder,
            "messageId": messageId,
            "attachmentId": attachmentId
        ]
        let bodyData = try? JSONSerialization.data(withJSONObject: payload)

        HTTPClient.shared.downloadData(
            endpoint: .downloadAttachment,
            bodyData: bodyData,
            completion: completion
        )
    }

    //compose and send a new email (multipart, supports attachments)
    func sendEmail(
        staffNumber: String,
        password: String,
        to: String,
        cc: String = "",
        bcc: String = "",
        subject: String,
        body: String,
        isHtml: Bool = false,
        attachments: [MultipartFile] = [],
        completion: @escaping (Result<EmailActionResponse, Error>) -> Void
    ) {
        let fields: [String: String] = [
            "StaffNumber": staffNumber,
            "Password": password,
            "To": to,
            "Cc": cc,
            "Bcc": bcc,
            "Subject": subject,
            "Body": body,
            "IsHtml": isHtml ? "true" : "false"
        ]

        HTTPClient.shared.sendMultipart(
            endpoint: .composeEmail,
            fields: fields,
            files: attachments,
            decodeTo: EmailActionResponse.self,
            completion: completion
        )
    }

    //reply to an existing email (multipart, supports attachments)
    func replyEmail(
        staffNumber: String,
        password: String,
        originalMessageId: String,
        originalSubject: String,
        folder: String = "inbox",
        to: String,
        cc: String = "",
        bcc: String = "",
        subject: String,
        body: String,
        isHtml: Bool = false,
        attachments: [MultipartFile] = [],
        completion: @escaping (Result<EmailActionResponse, Error>) -> Void
    ) {
        let fields: [String: String] = [
            "StaffNumber": staffNumber,
            "Password": password,
            "OriginalMessageId": originalMessageId,
            "OriginalSubject": originalSubject,
            "Folder": folder,
            "To": to,
            "Cc": cc,
            "Bcc": bcc,
            "Subject": subject,
            "Body": body,
            "IsHtml": isHtml ? "true" : "false"
        ]

        HTTPClient.shared.sendMultipart(
            endpoint: .emailReply,
            fields: fields,
            files: attachments,
            decodeTo: EmailActionResponse.self,
            completion: completion
        )
    }
}
