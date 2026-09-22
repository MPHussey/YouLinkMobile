//
//  InboxHeaderView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2026-07-21.
//

import SwiftUI
import UIKit

struct InboxHeaderView: View {
    enum Leading {
        case apps   // 2x2 grid -> opens the center menu (list screen)
        case back   // chevron  -> pops the detail screen
    }

    enum Trailing {
        case profile   // avatar -> jumps to profile (list / detail)
        case send      // paper plane -> sends the mail (compose)
    }

    let title: String
    let profileImageName: String?
    var leading: Leading = .apps
    var trailing: Trailing = .profile
    var onLeadingTap: () -> Void
    var onTrailingTap: () -> Void

    var body: some View {
        ZStack {
            Image("header-image")
                .resizable()
                .frame(height: 100 + safeAreaTopInset())
                .clipped()
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color(hex: "#01285B"), location: 0),
                    .init(color: Color(hex: "#01285B").opacity(0), location: 0.6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(alignment: .center) {
                //leading button -> apps grid on the list, back chevron on detail
                Button(action: onLeadingTap) {
                    Group {
                        switch leading {
                        case .apps:
                            AppsGridIcon()
                                .frame(width: 26, height: 26)
                        case .back:
                            Image(systemName: "chevron.left")
                                .font(.system(size: 22, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44, alignment: .leading)
                }

                Spacer()

                Button(action: onTrailingTap) {
                    Group {
                        switch trailing {
                        case .profile:
                            //same white half-rounded tab behind the avatar as the home header
                            ZStack {
                                Color.white
                                    .frame(width: 70, height: 70)
                                    .clipShape(
                                        RoundedCorners(radius: 30, corners: [.topLeft, .bottomLeft])
                                    )
                                profileImage
                            }
                        case .send:
                            Image(systemName: "paperplane")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44, alignment: .trailing)
                        }
                    }
                }
            }
            //title sits in an overlay so it stays centred whatever the button widths are
            .overlay(
                Text(title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
            )
            .padding(.leading, 20)
            //the profile tab runs flush to the screen edge, like the home header
            .padding(.trailing, trailing == .profile ? 0 : 20)
            .padding(.top, safeAreaTopInset() + 12)
        }
        .frame(height: 100 + safeAreaTopInset())
    }

    @ViewBuilder
    private var profileImage: some View {
        if let str = profileImageName?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           str != "N/A",
           let data = Data(base64Encoded: str),
           let uiImage = UIImage(data: data)
        {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        } else {
            Image("sample-user")
                .resizable()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }
}

//simple 2x2 rounded grid drawn to match the design apps icon
struct AppsGridIcon: View {
    var body: some View {
        GeometryReader { geo in
            let spacing: CGFloat = geo.size.width * 0.18
            let cell = (geo.size.width - spacing) / 2

            VStack(spacing: spacing) {
                HStack(spacing: spacing) {
                    roundedCell(cell)
                    roundedCell(cell)
                }
                HStack(spacing: spacing) {
                    roundedCell(cell)
                    roundedCell(cell)
                }
            }
        }
    }

    private func roundedCell(_ size: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: size * 0.28)
            .stroke(lineWidth: 2)
            .frame(width: size, height: size)
    }
}

private func safeAreaTopInset() -> CGFloat {
    UIApplication.shared
        .connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.windows.first }
        .first?.safeAreaInsets.top ?? 0
}
