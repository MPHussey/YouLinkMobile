//
//  EmailDetailView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI

struct EmailDetailView: View {
    let email: Email
    let profileImageName: String?
    var onOpen: () -> Void = {}

    @Binding var selectedTab: MainTabView.Tab
    @Environment(\.dismiss) private var dismiss
    @Environment(\.setTabBarHidden) private var setTabBarHidden
    @StateObject private var detailVM = EmailDetailViewModel()
    @State private var didOpen = false
    @State private var showReply = false

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.safeAreaInsets.bottom ?? 0
    }

    //full body preference: html -> text -> preview, so it is never blank
    private var bodyHtml: String {
        if !email.htmlBody.isEmpty { return email.htmlBody }
        if !email.textBody.isEmpty { return "<div>\(email.textBody)</div>" }
        return "<div>\(email.bodyPreview)</div>"
    }

    var body: some View {
        VStack(spacing: 0) {
            InboxHeaderView(
                title: "Inbox",
                profileImageName: profileImageName,
                leading: .back,
                trailing: .profile,
                onLeadingTap: { dismiss() },
                onTrailingTap: { selectedTab = .profile }
            )
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    //subject
                    Text(email.subject)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primary)
                        .fixedSize(horizontal: false, vertical: true)

                    //sender row
                    HStack(alignment: .center, spacing: 12) {
                        EmailAvatarView(initials: email.senderInitials)

                        Text(email.fromName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)

                        Spacer(minLength: 8)

                        if email.hasAttachments {
                            Image("attachment-pin")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 14, height: 14)
                                .foregroundColor(.secondary)
                        }

                        Text(email.displayTime)
                            .font(.system(size: 13))
                            .foregroundColor(.secondary)
                    }

                    //body
                    HTMLBodyView(html: bodyHtml)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    //attachments
                    if email.hasAttachments {
                        if detailVM.isLoadingAttachments {
                            HStack(spacing: 8) {
                                ProgressView()
                                Text("Loading attachments...")
                                    .font(.system(size: 13))
                                    .foregroundColor(.secondary)
                            }
                        } else {
                            ForEach(detailVM.attachments) { attachment in
                                AttachmentRow(
                                    attachment: attachment,
                                    isDownloading: detailVM.downloadingIds.contains(attachment.attachmentId),
                                    onDownload: {
                                        detailVM.download(
                                            attachment: attachment,
                                            messageId: email.messageId
                                        )
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 90 + safeAreaBottom())
            }

            //reply action
            ReplyButton {
                showReply = true
            }
            .padding(.bottom, 20 + safeAreaBottom())
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: [.top, .bottom])
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            //detail has its own back button, no bottom tab bar here
            setTabBarHidden(true)
            //mark as read once, when the email is actually opened
            if !didOpen {
                didOpen = true
                onOpen()
                if email.hasAttachments {
                    detailVM.loadAttachments(messageId: email.messageId)
                }
            }
        }
        .sheet(item: $detailVM.downloadedFile) { file in
            ActivityView(activityItems: [file.url])
        }
        .navigationDestination(isPresented: $showReply) {
            EmailComposeView(
                fromAddress: AuthService.shared.decodePayload()?.sub ?? "",
                mode: .reply(email),
                selectedTab: $selectedTab
            )
        }
    }
}

//single attachment row with a 3-dots menu -> Download
struct AttachmentRow: View {
    let attachment: EmailAttachment
    let isDownloading: Bool
    let onDownload: () -> Void

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color(hex: "#176EBC"))
                .frame(width: 4)

            Image(systemName: "doc")
                .foregroundColor(.secondary)
                .padding(.leading, 12)

            VStack(alignment: .leading, spacing: 2) {
                Text(attachment.fileName)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                Text(attachment.displaySize)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 10)

            Spacer(minLength: 8)

            if isDownloading {
                ProgressView()
                    .padding(.trailing, 14)
            } else {
                Menu {
                    Button {
                        onDownload()
                    } label: {
                        Label("Download", systemImage: "arrow.down.circle")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                        .frame(width: 44, height: 44)
                }
            }
        }
        .frame(height: 56)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(6)
    }
}

//share / save sheet for a downloaded file
struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ controller: UIActivityViewController, context: Context) {}
}

struct ReplyButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "arrowshape.turn.up.left")
                    .font(.system(size: 15, weight: .semibold))
                Text("Reply")
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundColor(Color(hex: "#176EBC"))
            .padding(.vertical, 10)
            .padding(.horizontal, 40)
            .overlay(
                Capsule().stroke(Color(hex: "#176EBC"), lineWidth: 1)
            )
        }
    }
}
