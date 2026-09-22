//
//  FeaturedLinksDialogboxView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-24.
//

import SwiftUI

struct FeaturedLinksDialogboxView: View {
    @StateObject private var vm=HomeViewModel()
    @Binding var isFeatureDialogboxOpen:Bool
    @Environment(\.openURL) private var openURL
    var columns: [GridItem] = Array(repeating: .init(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        VStack(alignment:.leading,spacing:16){
            HStack{
                Text("Featured Links")
                Spacer()
                Button(action:{
                    isFeatureDialogboxOpen=false
                }){
                    Image(systemName:"xmark")
                        .foregroundColor(.gray)
                        .padding(8)
                }
                
            }
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(vm.featuredLinks) { link in
                    Button {
                        if let url = link.redirectURL {
                            openURL(url)
                        }
                    } label: {
                        VStack(spacing: 8) {
                            QuickLinkIcon(url: link.imageURL)
                                .frame(width: 40, height: 40)
                            
                            Text(link.title)
                                .font(.caption)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(hex: "#004598"), lineWidth: 1)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal,20)
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
        .onAppear {
            vm.getQuickLinks()
        }
    }
}

