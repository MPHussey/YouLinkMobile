//
//  YouLinkMobileApp.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-21.
//

import SwiftUI

@main
struct YouLinkMobileApp: App {
    @StateObject private var auth = AuthViewModel()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Group {
                if auth.isCheckingSession {
                    SessionLoadingView()
                } else if auth.isLoggedIn {
                    MainTabView()
                        .environment(\.managedObjectContext,
                                      persistenceController.container.viewContext)
                } else {

                    LoginView()
                }
            }
            .environmentObject(auth)
            .preferredColorScheme(.light)
        }
    }
}

//shown briefly on launch while stored credentials are re-verified
struct SessionLoadingView: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                // patterned brand background, darkened towards the bottom
                Image("splash-screen-bg")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.black.opacity(0.42), location: 0),
                        .init(color: Color.black.opacity(0.55), location: 0.35),
                        .init(color: Color.black.opacity(0.82), location: 0.7),
                        .init(color: Color.black.opacity(0.97), location: 1)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                
                // app mark, sitting slightly above the centre like the design
                Image("login-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width * 0.36)
                    .offset(y: -geo.size.height * 0.07)
                
                VStack(spacing: 6) {
                    Spacer()
                    Image("srilankan-logo-white")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width * 0.52)
                    Text("Version \(AppInfo.displayVersion)")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.bottom, 28)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}
