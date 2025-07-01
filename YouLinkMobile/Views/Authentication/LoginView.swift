//
//  LoginView.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var auth: AuthViewModel
    @State private var username = ""
    @State private var password = ""
    var body: some View {
        GeometryReader { geo in
            ZStack {
               
                VStack(spacing: 0) {
                    Image("login-bg")
                        .resizable()
                        .scaledToFill()
                        .frame(height: geo.size.height * 0.6)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                    
                    Color.white
                        .ignoresSafeArea(edges: .bottom)
                }
                
                VStack {
                    Spacer()
                    
                   
                    ZStack(alignment: .top) {
                      
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                            .shadow(color: .black.opacity(0.1),
                                    radius: 8, x: 0, y: 4)
                        
                        
                        VStack(spacing: 24) {
                          
                            Spacer().frame(height: 50)
                            
                            // Title + subtitle
                            Image("login-name")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 36)
                            Image("login-sub-name")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 13)
                            
                        
                            VStack(spacing: 16) {
                                HStack {
                                    Image(systemName: "person")
                                        .foregroundColor(.gray)
                                    TextField("UserName", text: $username)
                                        .autocapitalization(.none)
                                        .disableAutocorrection(true)
                                }
                                Divider()
                                HStack {
                                    Image(systemName: "lock")
                                        .foregroundColor(.gray)
                                    SecureField("Password", text: $password)
                                }
                                Divider()
                            }
                            .padding(.horizontal, 24)
                            
                          
                            Button(action: {
                                auth.logIn(staffNumber: username, StaffPassword:password)
                            }) {
                                Text("Login")
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(hex: "#176EBC"))
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal, 24)
                            
                            Spacer().frame(height: 16)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.bottom, 24)
                        
                      
                        ZStack {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 100, height: 100)
                                .shadow(color: .black.opacity(0.1),
                                        radius: 4, x: 0, y: 2)
                            Image("login-logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 80, height: 80)
                        }
                       
                        .offset(y: -50)
                    }
                    .frame(width: geo.size.width * 0.85)
                    
                    .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer().frame(height: 20)
                    
                    // Footer
                    VStack(spacing: 4) {
                        Image("it-systems-logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height:25)
                        Text("Version 1.0")
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, geo.safeAreaInsets.bottom)
                }
                .ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    LoginView()
}
