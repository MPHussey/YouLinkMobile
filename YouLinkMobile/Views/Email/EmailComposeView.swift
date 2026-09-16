//
//  EmailComposeView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI
import UniformTypeIdentifiers

struct EmailComposeView: View {
    @StateObject private var vm: EmailComposeViewModel

    @Binding var selectedTab: MainTabView.Tab
    @Environment(\.dismiss) private var dismiss

    @State private var showFileImporter = false

    init(
        fromAddress: String,
        mode: ComposeMode = .new,
        selectedTab: Binding<MainTabView.Tab>
    ) {
        _vm = StateObject(wrappedValue: EmailComposeViewModel(fromAddress: fromAddress, mode: mode))
        _selectedTab = selectedTab
    }

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.safeAreaInsets.bottom ?? 0
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                InboxHeaderView(
                    title: vm.screenTitle,
                    profileImageName: nil,
                    leading: .back,
                    trailing: .send,
                    onLeadingTap: { dismiss() },
                    onTrailingTap: { vm.send() }
                )

                ScrollView {
                    VStack(spacing: 0) {
                        //From is fixed to the signed-in user
                        fieldRow(label: "From") {
                            Text(vm.fromAddress)
                                .font(.system(size: 15))
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        fieldRow(label: "To") {
                            TextField("", text: $vm.to)
                                .font(.system(size: 15))
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                        }

                        fieldRow(label: "Subject") {
                            TextField("", text: $vm.subject)
                                .font(.system(size: 15))
                        }

                        //attachments row
                        attachmentsSection

                        //message body
                        ZStack(alignment: .topLeading) {
                            if vm.messageBody.isEmpty {
                                Text("Write your message...")
                                    .font(.system(size: 15))
                                    .foregroundColor(Color(.placeholderText))
                                    .padding(.top, 8)
                            }
                            TextEditor(text: $vm.messageBody)
                                .font(.system(size: 15))
                                .frame(minHeight: 180)
                                .scrollContentBackground(.hidden)
                        }
                        .padding(.top, 8)
                        .padding(.horizontal, 20)
                    }
                    .padding(.bottom, 100 + safeAreaBottom())
                }
            }

            //sending overlay
            if vm.isSending {
                Color.black.opacity(0.15).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#176EBC")))
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
            }
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: [.top, .bottom])
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.item],
            allowsMultipleSelection: true
        ) { result in
            if case .success(let urls) = result {
                vm.addAttachments(urls: urls)
            }
        }
        .alert(
            "Compose",
            isPresented: .constant(vm.errorMessage != nil),
            actions: { Button("OK") { vm.errorMessage = nil } },
            message: { Text(vm.errorMessage ?? "") }
        )
        .onChange(of: vm.didSend) { sent in
            if sent { dismiss() }
        }
    }

    //attachment picker + chips
    @ViewBuilder
    private var attachmentsSection: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Text("Attachments :")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)

                Spacer()

                Button {
                    showFileImporter = true
                } label: {
                    Image(systemName: "paperclip")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "#176EBC"))
                }
            }

            if !vm.attachments.isEmpty {
                VStack(spacing: 6) {
                    ForEach(vm.attachments) { file in
                        HStack(spacing: 8) {
                            Image(systemName: "doc")
                                .foregroundColor(.secondary)
                            Text(file.fileName)
                                .font(.system(size: 13))
                                .foregroundColor(.primary)
                                .lineLimit(1)
                            Spacer()
                            Button {
                                vm.removeAttachment(file)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 12)
                        .frame(height: 40)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(6)
                    }
                }
            }

            Divider()
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }

    //label + input + underline, matching the mockup rows
    @ViewBuilder
    private func fieldRow<Content: View>(
        label: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Text("\(label) :")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                content()
            }
            Divider()
        }
        .padding(.horizontal, 20)
        .padding(.top, 18)
    }
}
