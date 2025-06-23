//
//  CarouselView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-22.
//

// CarouselView.swift
// YouLinkMobile

import SwiftUI

struct CarouselView<Content: View>: View {
    /// Total slides
    let pageCount: Int
    /// Which slide you’re on (0..<pageCount)
    @Binding var currentIndex: Int
    /// How wide each page is as a fraction of the full width (e.g. 0.8 = 80%)
    let pageWidthFactor: CGFloat
    /// Content builder
    let content: (Int) -> Content

    init(
        pageCount: Int,
        currentIndex: Binding<Int>,
        pageWidthFactor: CGFloat = 0.8,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.pageWidthFactor = pageWidthFactor
        self.content = content
    }

    var body: some View {
        GeometryReader { geo in
            let fullW = geo.size.width
            let pageW = fullW * pageWidthFactor
            let padding = (fullW - pageW) / 2

            TabView(selection: $currentIndex) {
                ForEach(0..<pageCount, id: \.self) { idx in
                    content(idx)
                        .frame(width: pageW, height: geo.size.height)
                        .cornerRadius(12)
                        .tag(idx)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .padding(.horizontal, padding)
            .frame(width: fullW, height: geo.size.height)
            // custom dots
            .overlay(
                HStack(spacing: 8) {
                    ForEach(0..<pageCount, id: \.self) { idx in
                        Circle()
                            .fill(idx == currentIndex
                                  ? Color.white
                                  : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 12),
                alignment: .bottom
            )
        }
    }
}

