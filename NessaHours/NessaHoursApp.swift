//
//  NessaHoursApp.swift
//  NessaHours
//
//  Created by cs2023 on 10/17/24.
//

import SwiftUI

@main
struct NessaHoursApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
