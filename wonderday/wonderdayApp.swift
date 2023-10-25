//
//  wonderdayApp.swift
//  wonderday
//
//  Created by How Sun on 2023/9/27.
//

import SwiftUI

@main
struct wonderdayApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
