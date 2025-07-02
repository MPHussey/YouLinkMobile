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
    
    let fullName = "James Syahir (25222)"
    let role     = "SOFTWARE DEVELOPMENT MANAGER"
    let phone    = "1234"
    
    let annual   = (used: 2, total: 21)
    let medical  = (used: 5, total: 7)
    let duty     = (used: 0, total: 7)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack(spacing:0) {
                    Image("bg-profile")
                        .resizable()
                        .scaledToFill()
                        .frame(height: geo.size.height * 0.3)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                    
                    Color.white
                        .ignoresSafeArea(edges: .bottom)
                }
                ScrollView(showsIndicators: false){
                    VStack(spacing: 50) {
                        Text("Profile")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .padding(.top, geo.safeAreaInsets.top + 16)
                        
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: .black.opacity(0.1),
                                        radius: 4, x: 0, y: 2)
                            
                            VStack(spacing: 8) {
                                Spacer().frame(height: 40)
                                Text("\(vm.loggedInUserDetails!.staffName) (\(vm.loggedInUserDetails!.staffNumber))")
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                Text(role)
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                HStack(spacing: 4) {
                                    Image(systemName: "phone.fill")
                                        .foregroundColor(.gray)
                                    Text(phone)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                                .padding(.top, 4)
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
                                //                                Image("bg-profile-pic")
                                //                                    .resizable()
                                //                                    .scaledToFill()
                                //                                    .frame(width: 72, height: 72)
                                //                                    .clipShape(Circle())
                            }
                            .offset(y: -40)
                        }
                        .frame(width: geo.size.width * 0.9)
                        .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Leave Balance")
                                .font(.headline)
                            
                            balanceRow(label: "Annual",
                                       used: annual.used,
                                       total: annual.total,
                                       color: .green)
                            
                            balanceRow(label: "Medical",
                                       used: medical.used,
                                       total: medical.total,
                                       color: .green)
                            
                            balanceRow(label: "Duty Leave",
                                       used: duty.used,
                                       total: duty.total,
                                       color: .green)
                            
                            Button("Apply Leave") {
                                
                            }
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "#176EBC"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1),
                                    radius: 4, x: 0, y: 2))
                        .frame(width: geo.size.width * 0.9)
                        
                        Button(action: {
                            auth.logOut()
                        }) {
                            HStack {
                                Image(systemName: "power")
                                Text("Sign out")
                            }
                            .foregroundColor(.red)
                            .font(.headline)
                        }
                        .padding(.top, 8)
                        
                        Spacer()
                            .frame(height: geo.safeAreaInsets.bottom + 16)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    @ViewBuilder
    private func balanceRow(
        label: String, used: Int, total: Int, color: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                Spacer()
                Text("\(used)/\(total)")
            }
            .font(.subheadline)
            BalanceBar(fraction: Double(used)/Double(total), color: color)
                .frame(height: 6)
        }
    }
    
    
    @ViewBuilder
    private var profileImage: some View {
        if let str = vm.loggedInUserDetails?.profilephoto
            .trimmingCharacters(in: .whitespacesAndNewlines),
           str != "N/A",
           let data = Data(base64Encoded: str),
           let uiImage = UIImage(data: data)
        {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width:72, height:72)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            //                .clipShape(Circle())
            //                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            
            //            Image("bg-profile-pic")
            //                .resizable()
            //                .scaledToFill()
            //                .frame(width: 72, height: 72)
            //                .clipShape(Circle())
        } else {
            Image("sample-user")
                .resizable()
                .scaledToFill()
                .frame(width:72, height:72)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            //                .clipShape(Circle())
            //                .overlay(Circle().stroke(Color.white, lineWidth: 2))
        }
    }
}


struct BalanceBar: View {
    let fraction: Double
    let color: Color
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.gray.opacity(0.2))
                Capsule()
                    .fill(color)
                    .frame(width: geo.size.width * CGFloat(fraction))
            }
        }
    }
}

//#Preview {
//    ProfileView()
//}
