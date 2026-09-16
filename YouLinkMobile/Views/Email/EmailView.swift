//
//  EmailView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI

struct EmailView: View {
    @StateObject private var vm = EmailViewModel()

    @Binding var selectedTab: MainTabView.Tab
    @Binding var showCenterMenu: Bool

    @State private var showCompose = false

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.safeAreaInsets.bottom ?? 0
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                InboxHeaderView(
                    title: "Inbox",
                    profileImageName: vm.loggedInUserDetails?.profilephoto,
                    leading: .apps,
                    trailing: .profile,
                    onLeadingTap: {
                        showCenterMenu = true
                    },
                    onTrailingTap: {
                        selectedTab = .profile
                    }
                )

                //All / Unread filter chips
                EmailFilterBar(selectedFilter: $vm.selectedFilter)
                    .padding(.vertical, 12)

                //email list
                if vm.isLoading && vm.emails.isEmpty {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#176EBC")))
                    Spacer()
                } else if let error = vm.errorMessage, vm.emails.isEmpty {
                    Spacer()
                    VStack(spacing: 12) {
                        Text(error)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") { vm.fetchEmails() }
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(Color(hex: "#176EBC"))
                    }
                    .padding(.horizontal, 40)
                    Spacer()
                } else if vm.filteredEmails.isEmpty {
                    Spacer()
                    Text(vm.selectedFilter == .unread ? "No unread emails" : "No emails")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.filteredEmails) { email in
                                NavigationLink {
                                    EmailDetailView(
                                        email: email,
                                        profileImageName: vm.loggedInUserDetails?.profilephoto,
                                        onOpen: { vm.markAsRead(email) },
                                        selectedTab: $selectedTab
                                    )
                                } label: {
                                    EmailRowView(email: email)
                                }
                                .buttonStyle(PlainButtonStyle())

                                Divider()
                                    .padding(.leading, 20)
                            }
                        }
                        .padding(.bottom, 80 + safeAreaBottom())
                    }
                    .refreshable { vm.fetchEmails() }
                }
            }

            //floating "New Mail" button -> list screen only
            NewMailButton {
                showCompose = true
            }
            .padding(.trailing, 20)
            .padding(.bottom, 110 + safeAreaBottom())
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            if vm.emails.isEmpty {
                vm.fetchEmails()
            }
        }
        .navigationDestination(isPresented: $showCompose) {
            EmailComposeView(
                fromAddress: vm.loggedInUserDetails?.sub ?? "",
                selectedTab: $selectedTab
            )
        }
    }
}

struct EmailFilterBar: View {
    @Binding var selectedFilter: EmailFilter

    var body: some View {
        HStack(spacing: 10) {
            ForEach(EmailFilter.allCases) { filter in
                let isSelected = selectedFilter == filter

                Button {
                    selectedFilter = filter
                } label: {
                    Text(filter.rawValue)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isSelected ? .white : Color(hex: "#176EBC"))
                        .padding(.vertical, 7)
                        .padding(.horizontal, 20)
                        .background(
                            Group {
                                if isSelected {
                                    Capsule().fill(Color(hex: "#176EBC"))
                                } else {
                                    Capsule().stroke(Color(hex: "#176EBC"), lineWidth: 1)
                                }
                            }
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }

            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
