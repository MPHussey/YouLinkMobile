//
//  EmailRowView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI

struct EmailRowView: View {
    let email: Email

    private var isUnread: Bool { !email.isRead }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            //sender avatar built from the name initials
            EmailAvatarView(initials: email.senderInitials)

            //sender / subject / preview
            VStack(alignment: .leading, spacing: 3) {
                Text(email.fromName)
                    .font(.system(size: 15))
                    .fontWeight(isUnread ? .bold : .semibold)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(email.subject)
                    .font(.system(size: 14))
                    .fontWeight(isUnread ? .semibold : .regular)
                    .foregroundColor(.primary)
                    .lineLimit(1)

                Text(email.previewText)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            //time + attachment indicator
            VStack(alignment: .trailing, spacing: 8) {
                if email.hasAttachments {
                    Image("attachment-pin")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 14, height: 14)
                        .foregroundColor(.secondary)
                }

                Text(email.displayTime)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(
            //unread rows get a subtle highlight + coloured leading accent bar
            ZStack(alignment: .leading) {
                isUnread ? Color(hex: "#176EBC").opacity(0.06) : Color.clear

                if isUnread {
                    Rectangle()
                        .fill(Color(hex: "#176EBC"))
                        .frame(width: 4)
                }
            }
        )
    }
}

struct EmailAvatarView: View {
    let initials: String

    //deterministic colour so the same sender always keeps the same avatar
    private var palette: (bg: Color, fg: Color) {
        let colors: [(bg: String, fg: String)] = [
            ("#E3ECFB", "#2C6BE0"), // blue
            ("#FBE3E3", "#C0392B"), // red
            ("#F0E3FB", "#7D3CC0"), // purple
            ("#E3FBEA", "#1E9E52"), // green
            ("#FBF1E3", "#D98324")  // orange
        ]
        let index = abs(initials.hashValue) % colors.count
        let chosen = colors[index]
        return (Color(hex: chosen.bg), Color(hex: chosen.fg))
    }

    var body: some View {
        Text(initials)
            .font(.system(size: 15, weight: .bold))
            .foregroundColor(palette.fg)
            .frame(width: 44, height: 44)
            .background(palette.bg)
            .clipShape(Circle())
    }
}
