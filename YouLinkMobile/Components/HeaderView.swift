//
//  HeaderView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-22.
//

import SwiftUI

struct HeaderView: View {
    let staffName:String
    let profileImageName:String
    
    var body: some View {
        ZStack{
            //Color(hex:"#01285B").ignoresSafeArea(edges: .top)
            Image("header-image")
                .resizable()
                .frame(height: 100 + safeAreaTop())  // adjust height as needed
                .clipped()
            LinearGradient(
                gradient: Gradient(stops: [
                      .init(color: Color(hex: "#01285B"), location: 0),
                      .init(color: Color(hex: "#01285B").opacity(0), location: 0.6)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            
            HStack(alignment: .center , spacing:13){
                Image("hamburger-button")
                    .resizable()
                    .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                    .frame(width:24, height: 24)
                VStack(alignment:.leading,spacing:-5){
                    Text("Hello")
                        .font(.headline)
                        .foregroundColor(Color(hex:"#70ABFF"))
                    Text(staffName)
                        .font(.headline)
                        .bold()
                        .foregroundColor(.white)
                }
                Spacer()
                ZStack{
                    Color.white
                        .frame(width:70, height: 70)
                        .clipShape(
                          RoundedCorners(radius: 30,
                                         corners: [.topLeft, .bottomLeft])
                        )
                    Image("sample-user")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))

                }
//                Image("sample-user")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width:60, height:60)
//                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
//                    .overlay(Circle().stroke(Color.white, lineWidth: 2))
            }
            .padding(.leading)
              .padding(.top, safeAreaTop() + 12)
           
        }.frame(height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/ + safeAreaTop())
    }
}


struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

private func safeAreaTop() -> CGFloat {
      UIApplication.shared
          .connectedScenes
          .compactMap { ($0 as? UIWindowScene)?.windows.first }
          .first?.safeAreaInsets.top ?? 0
}


#Preview {
    HeaderView(staffName:"Hasantha Pathirana", profileImageName:"Image")
}
