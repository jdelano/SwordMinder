//
//  SwordMinderApp.swift
//  SwordMinder
//
//  Created by John Delano on 6/17/22.
//

import SwiftUI

@main
struct SwordMinderApp: App {
    @StateObject var swordMinder = SwordMinder()
    var body: some Scene {
        WindowGroup {
            SwordMinderView()
                .environmentObject(swordMinder)
        }
    }
}
