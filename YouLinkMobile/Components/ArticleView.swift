//
//  ArticleView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-26.
//

import SwiftUI

struct ArticleView: View {
    let articles:[Article]
    
    private func parseDate(_ str: String) -> (day: String, month: String) {
        let inFmt = DateFormatter()
        inFmt.dateFormat = "dd-MM-yyyy"
        guard let d = inFmt.date(from: str) else {
            return ("", "")
        }
        let dayFmt = DateFormatter()
        dayFmt.dateFormat = "d"
        let moFmt = DateFormatter()
        moFmt.dateFormat = "MMM"
        return ( dayFmt.string(from: d),
                 moFmt.string(from: d).uppercased() )
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing:8){
            Text("Official Articles of \(String(Calendar.current.component(.year, from: Date())))")
                .font(.headline)
                .padding(.horizontal, 20)
            ScrollView(.horizontal, showsIndicators: false){
                LazyHStack(spacing: 16) {
                    ForEach(articles){article in
                        articleCard(for:article)
                    }
                    
                }
                .padding(.horizontal, 20)
            }
            .frame(height: 120)
        }
        .padding(.top, 16)
    }
    
    @ViewBuilder
    private func articleCard(for article:Article)->some View{
        HStack(spacing:0){
            // Date badge with only top corners rounded
            VStack(spacing: 0) {
                Color.gray.opacity(0.2)
                    .frame(height: 50)
                    .overlay(
                        Text(parseDate(article.date).day)
                            .font(.title3)
                            .bold()
                    )
                Color.red
                    .frame(height: 24)
                    .overlay(
                        Text(parseDate(article.date).month)
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                    )
            }
            .frame(width: 70)
            .clipShape(
                RoundedCorner(radius: 15, corners: [.topLeft, .topRight])
            )
            .padding(.leading, 12)
            .padding(.vertical, 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(2)
                Text("by \(article.subHeading)")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 12)
            .padding(.vertical, 12)
            Spacer()
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .frame(width: 300, height: 100)
    }
}



struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let pb = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(pb.cgPath)
    }
}


//#Preview {
//    ArticleView()
//}
