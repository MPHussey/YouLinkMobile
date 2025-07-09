//
//  CenterMenuView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-09.
//

import SwiftUI

struct CenterMenuView: View {
    @Binding var isPresented: Bool
    
    // Track which sections are expanded
    @State private var expandApplications = false
    @State private var expandCorporate   = false
    @State private var expandDivisions   = false
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "#01285B"),
                    Color(hex: "#000E3F")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            Image("center-tab-bg")
                .resizable()
                .scaledToFit()
                .frame(width: 200)              // adjust to taste
                .opacity(0.2)
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .bottomTrailing)
            
            VStack(spacing: 24){
                // Close button
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                    }
                }
                
                // Expandable list
                ScrollView {
                    VStack {
                        SectionView(
                            title: "Applications",
                            isExpanded: $expandApplications
                        ) {
                            // These are your real items—just indent them a bit
                            VStack(alignment: .leading, spacing: 8) {
                                Text("AeroOps")
                                Text("ARD - Intranet")
                                Text("AQRS (GHDR)")
                                // …etc…
                            }
                            .padding(.leading, 12)
                        }
                        
                        SectionView(
                            title: "Corporate Information",
                            isExpanded: $expandCorporate
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("About Us")
                                Text("Mission & Vision")
                            }
                            .padding(.leading, 12)
                        }
                        
                        SectionView(
                            title: "Divisions",
                            isExpanded: $expandDivisions
                        ) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("HR")
                                Text("Engineering")
                            }
                            .padding(.leading, 12)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                // push everything up if it doesn’t fill
                Spacer()
            }
            .foregroundColor(.white)
        }
    }
}

/// A reusable “DisclosureGroup” style section
struct SectionView<Content: View>: View {
    let title: String
    @Binding var isExpanded: Bool
    let content: () -> Content
    
    init(
        title: String,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self._isExpanded = isExpanded
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button { isExpanded.toggle() } label: {
                HStack {
                    Text(title)
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                        .foregroundColor(.white)
                }
                .padding(.vertical, 8)
            }
            
            Rectangle()
                .fill(Color.white.opacity(0.3))
                .frame(height: 1)
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    content()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
            }
        }
    }
}

