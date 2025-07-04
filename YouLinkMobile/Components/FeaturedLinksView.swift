//
//  FeaturedLinksView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-24.
//

import SwiftUI

struct FeaturedLinksView: View {
    let links: [FeaturedLink]
    @Binding var selectedIndex: Int?
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        VStack(alignment:.leading,spacing:8){
            HStack{
                Text("Featured Links")
                    .font(.headline)
                Spacer()
                Button("View All"){
                    
                }
                .font(.subheadline)
            }
            .padding(.horizontal,20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing:16) {
                    // enumerate so we can write back to selectedIndex
                    ForEach(Array(links.enumerated()), id: \.offset) { index, link in
                        Button {
                            selectedIndex = index
                            if let url = URL(string: link.redirectUrl) {
                                openURL(url)
                            }
                        } label: {
                            VStack(spacing:8) {
                                Image(link.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 60)
                                Text(link.title)
                                    .font(.subheadline)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .frame(width: 120, height: 130)
                            .background(
                                RoundedRectangle(cornerRadius:12)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(hex:"#004598"),
                                                Color(hex:"#001C4B")
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                            )
                            .shadow(color: Color.black.opacity(0.2),
                                    radius: 4, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal,20)
            }
            .frame(height: 160)
        }
    }
}

//#Preview {
//    FeaturedLinksView()
//}
