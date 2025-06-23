//
//  YouLinkMobileApp.swift
//  YouLinkMobile
//
//  Created by Hasantha Pathirana on 2025-06-21.
//

import SwiftUI

@main
struct YouLinkMobileApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
