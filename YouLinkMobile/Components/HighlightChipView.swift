//
//  HighlightChipView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import SwiftUI

struct HighlightChipView: View {
    let highlightLinks:[HighLight]
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(alignment:.leading,spacing:8){
            Text("Highlights")
                .font(.headline)
                .padding(.horizontal,20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(highlightLinks) { item in
                        Button {
                            // attempt to open the item’s URL
                            if let url = URL(string: item.redirectUrl) {
                                openURL(url)
                            }
                        } label: {
                            Text(item.title)
                                .font(.subheadline)
                                .foregroundColor(Color(hex: "#176EBC"))
                                .padding(.vertical, 8)
                                .padding(.horizontal, 16)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .stroke(Color(hex: "#176EBC"), lineWidth: 1)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())  // keep your styling intact
                    }
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 50)
        }
        .padding(.top,16)
    }
}


