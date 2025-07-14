//
//  CenterMenuView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-07-09.
//

import SwiftUI

struct CenterMenuView: View {
    @Binding var isPresented: Bool
    
    @StateObject private var vm = CenterMenuViewModel()
    @Environment(\.openURL) private var openURL
    // Track which sections are expanded
    @State private var expandApplications = false
    @State private var expandCorporate   = false
    @State private var expandDivisions   = false
    
    private let sectionOrder: [(key: String, title: String)] = [
        ("applications", "Applications"),
        ("corporate",    "Corporate Information"),
        ("divisions",    "Divisions")
    ]
    
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
            
            VStack(spacing: 24) {
                HStack { Spacer()
                    Button { isPresented = false } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(sectionOrder, id: \.key) { section in
                            // pull out the items array
                            if let items = vm.menuData[section.key] {
                                SectionView(
                                    title: section.title,
                                    isExpanded: Binding(
                                        get: { vm.isExpanded(sectionKey: section.key) },
                                        set: { _ in vm.toggle(sectionKey: section.key) }
                                    )
                                ) {
                                    // iterate your actual links
                                    ForEach(items) { item in
                                        Button {
                                            if let url = URL(string: item.url) {
                                                openURL(url)
                                            }
                                        } label: {
                                            Text(item.label)
                                                .font(.subheadline)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 4)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
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

