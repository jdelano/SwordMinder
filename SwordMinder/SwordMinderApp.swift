//
//  SwordMinderApp.swift
//  SwordMinder
//
//  Created by John Delano on 12/22/21.
//

import SwiftUI

@main
struct SwordMinderApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
