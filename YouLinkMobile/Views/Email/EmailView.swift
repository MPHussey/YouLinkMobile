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
    @Environment(\.setTabBarHidden) private var setTabBarHidden

    //compose button collapses to icon-only once the list leaves the top
    @State private var isComposeExpanded = true
    //on-screen y of the list top when it is not scrolled
    @State private var scrollTopBaseline: CGFloat?

    private func safeAreaBottom() -> CGFloat {
        UIApplication.shared
            .connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows.first }
            .first?.safeAreaInsets.bottom ?? 0
    }

    //full "New Mail" only at the very top of the list, icon-only anywhere below it
    private func updateComposeButton(for listTop: CGFloat) {
        //remember where the list starts, then work with how far it has moved from there
        if scrollTopBaseline == nil { scrollTopBaseline = listTop }
        let offset = listTop - (scrollTopBaseline ?? listTop)

        let atTop = offset > -20
        if isComposeExpanded != atTop {
            isComposeExpanded = atTop
        }
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
                        //reports how far the list has scrolled; kept as a background of the
                        //whole stack because LazyVStack drops children that scroll off screen
                        .background(
                            GeometryReader { geo in
                                let listTop = geo.frame(in: .global).minY
                                Color.clear
                                    .onAppear { updateComposeButton(for: listTop) }
                                    .onChange(of: listTop) { updateComposeButton(for: $0) }
                            }
                        )
                        .padding(.bottom, 80 + safeAreaBottom())
                    }
                    .refreshable { vm.fetchEmails() }
                }
            }

            //floating "New Mail" button -> list screen only
            NewMailButton(isExpanded: isComposeExpanded) {
                showCompose = true
            }
            .padding(.trailing, 20)
            .padding(.bottom, 110 + safeAreaBottom())
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(edges: .top)
        .onAppear {
            //back on the inbox list (also after popping detail / compose)
            setTabBarHidden(false)
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
