//
//  EmailViewModel.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI

enum EmailFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case unread = "Unread"

    var id: String { rawValue }
}

class EmailViewModel: ObservableObject {
    @Published var selectedFilter: EmailFilter = .all

    @Published var isLoading = false
    @Published var errorMessage: String?

    @Published var loggedInUserDetails: JWTPayload? = AuthService.shared.decodePayload()

    //emails loaded from the service
    @Published var emails: [Email] = []

    private let emailService = EmailService.shared

    //emails after the selected filter is applied
    var filteredEmails: [Email] {
        switch selectedFilter {
        case .all:
            return emails
        case .unread:
            return emails.filter { !$0.isRead }
        }
    }

    //load the inbox using the credentials stored at sign-in
    func fetchEmails(folder: String = "inbox", count: Int = 20, offset: Int = 0) {
        guard let creds = AuthService.shared.storedCredentials else {
            errorMessage = "Missing credentials. Please sign in again."
            return
        }

        isLoading = true
        errorMessage = nil

        emailService.getEmailList(
            staffNumber: creds.staffNumber,
            password: creds.password,
            folder: folder,
            count: count,
            offset: offset
        ) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let emails):
                    self?.emails = emails
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }

    //mark an email as read when it is opened, then reflect it locally
    func markAsRead(_ email: Email, folder: String = "inbox") {
        guard !email.isRead else { return }
        guard let creds = AuthService.shared.storedCredentials else { return }

        //optimistically flip the local state so the row updates immediately
        setReadState(messageId: email.messageId, isRead: true)

        emailService.markAsRead(
            staffNumber: creds.staffNumber,
            password: creds.password,
            folder: folder,
            messageId: email.messageId
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    if !response.success {
                        //server rejected -> roll back
                        self?.setReadState(messageId: email.messageId, isRead: false)
                    }
                case .failure:
                    //network failure -> roll back
                    self?.setReadState(messageId: email.messageId, isRead: false)
                }
            }
        }
    }

    private func setReadState(messageId: String, isRead: Bool) {
        if let index = emails.firstIndex(where: { $0.messageId == messageId }) {
            emails[index].isRead = isRead
        }
    }
}
