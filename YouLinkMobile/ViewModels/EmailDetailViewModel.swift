//
//  EmailDetailViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI

//wraps a saved file url so it can drive a `.sheet(item:)`
struct DownloadedFile: Identifiable {
    let id = UUID()
    let url: URL
}

class EmailDetailViewModel: ObservableObject {
    @Published var attachments: [EmailAttachment] = []
    @Published var isLoadingAttachments = false
    @Published var errorMessage: String?

    //attachmentIds currently downloading -> drives per-row spinners
    @Published var downloadingIds: Set<String> = []
    //set when a download finishes -> presents the share / save sheet
    @Published var downloadedFile: DownloadedFile?

    private let service = EmailService.shared

    //load the attachment list for an email that has attachments
    func loadAttachments(messageId: String, folder: String = "inbox") {
        guard let creds = AuthService.shared.storedCredentials else { return }

        isLoadingAttachments = true
        errorMessage = nil

        service.getAttachments(
            staffNumber: creds.staffNumber,
            password: creds.password,
            folder: folder,
            messageId: messageId
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingAttachments = false
                switch result {
                case .success(let attachments):
                    self?.attachments = attachments
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    //download one attachment, save it to disk, then present it
    func download(
        attachment: EmailAttachment,
        messageId: String,
        folder: String = "inbox"
    ) {
        guard let creds = AuthService.shared.storedCredentials else { return }
        guard !downloadingIds.contains(attachment.attachmentId) else { return }

        downloadingIds.insert(attachment.attachmentId)
        errorMessage = nil

        service.downloadAttachment(
            staffNumber: creds.staffNumber,
            password: creds.password,
            folder: folder,
            messageId: messageId,
            attachmentId: attachment.attachmentId
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.downloadingIds.remove(attachment.attachmentId)
                switch result {
                case .success(let data):
                    if let url = self?.saveToTemp(data: data, fileName: attachment.fileName) {
                        self?.downloadedFile = DownloadedFile(url: url)
                    } else {
                        self?.errorMessage = "Could not save the file."
                    }
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    //write the bytes to a temp file so it can be shared / previewed
    private func saveToTemp(data: Data, fileName: String) -> URL? {
        let safeName = fileName.isEmpty ? "attachment" : fileName
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(safeName)
        do {
            try data.write(to: url, options: .atomic)
            return url
        } catch {
            print("� Attachment save error: \(error)")
            return nil
        }
    }
}
