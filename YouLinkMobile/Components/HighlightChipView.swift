//
//  HighlightChipView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import SwiftUI

struct HighlightChipView: View {
    let highlightLinks:[HighLight]
    
    var body: some View {
        VStack(alignment:.leading,spacing:8){
            Text("Highlights")
                .font(.headline)
                .padding(.horizontal,20)
            
            ScrollView(.horizontal,showsIndicators: false){
                LazyHStack(spacing:12){
                    ForEach(highlightLinks){item in
                        Text(item.title)
                            .font(.subheadline)
                            .foregroundColor(Color(hex:"#176EBC"))
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                             .overlay(
                                 RoundedRectangle(cornerRadius:13)
                                     .stroke(Color(hex: "#176EBC"), lineWidth: 1)
                             )
                    }
                }
                .padding(.horizontal,20)
            }
            .frame(height: 50)
        }
        .padding(.top,16)
    }
}


