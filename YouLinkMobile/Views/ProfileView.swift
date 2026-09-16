//
//  ProfileView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @StateObject private var vm = ProfileViewModel()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(hex: "#F2F3F5")
                    .ignoresSafeArea()
                
                VStack(spacing:0) {
                    Image("bg-profile")
                        .resizable()
                        .scaledToFill()
                        .frame(height: geo.size.height * 0.3)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                    
                    Spacer(minLength: 0)
                }
                ScrollView(showsIndicators: false){
                    VStack(spacing: 24) {
                        Text("Profile")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, geo.safeAreaInsets.top)
                        
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1),
                                        radius: 4, x: 0, y: 2)
                            
                            VStack(spacing: 8) {
                                Spacer().frame(height: 40)
                                Text("\(vm.staffName) (\(vm.staffNumber))")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                Text(vm.designation)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                    .multilineTextAlignment(.center)
                                HStack(spacing: 4) {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.gray)
                                    Text(vm.contactNumber)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 4)
                                
                                Button(action: {
                                    auth.logOut()
                                }) {
                                    HStack(spacing: 8) {
                                        Image(systemName: "power")
                                        Text("Sign out")
                                    }
                                    .font(.headline)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        Capsule()
                                            .stroke(Color.red, lineWidth: 1.5)
                                    )
                                }
                                .padding(.top, 20)
                                
                                Spacer().frame(height: 16)
                            }
                            .padding(.horizontal, 16)
                            
                            // Avatar circle
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 80, height: 80)
                                    .shadow(color: .black.opacity(0.1),
                                            radius: 4, x: 0, y: 2)
                                profileImage
                            }
                            .offset(y: -40)
                        }
                        .frame(width: geo.size.width * 0.9)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 26)   // room for the avatar overhang
                        
                        ProfileSupportCardView()
                            .frame(width: geo.size.width * 0.9)
                        
                        Spacer()
                            .frame(height: geo.safeAreaInsets.bottom + 16)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    @ViewBuilder
    private var profileImage: some View {
        let trimmed = vm.loggedInUserDetails?.profilephoto?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let str = trimmed,
           !str.isEmpty,
           str != "N/A",
           let data = Data(base64Encoded: str),
           let uiImage = UIImage(data: data)
        {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        } else {
            Image("sample-user")
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }
}

/// App version + IT Service Desk details shown under the profile card.
struct ProfileSupportCardView: View {
    private let serviceDeskExtension = "3000"
    
    var body: some View {
        VStack(spacing: 10) {
            Text("V \(AppInfo.displayVersion)")
                .font(.footnote)
                .foregroundColor(.gray)
            
            VStack(spacing: 2) {
                (Text("Need help? ").bold()
                 + Text("Contact IT Service Desk"))
                Text("(Ext: ") + Text(serviceDeskExtension).bold() + Text(") | 24×7 Support")
            }
            .font(.footnote)
            .foregroundColor(.gray)
            .multilineTextAlignment(.center)
            
            Image("it-systems-logo-1")
                .resizable()
                .scaledToFit()
                .frame(height: 34)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(RoundedRectangle(cornerRadius: 16)
            .fill(Color.white)
            .shadow(color: .black.opacity(0.1),
                    radius: 4, x: 0, y: 2))
    }
}

enum AppInfo {
    /// e.g. "1.0.0.2" – marketing version plus build number from the bundle.
    static var displayVersion: String {
        let info = Bundle.main.infoDictionary
        let short = info?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = info?["CFBundleVersion"] as? String ?? "0"
        return "\(short).\(build)"
    }
}

//#Preview {
//    ProfileView()
//}
