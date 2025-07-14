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
                if auth.isLoggedIn {
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
