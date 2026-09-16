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
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 20) {
                Image("login-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "#176EBC")))
            }
        }
    }
}
