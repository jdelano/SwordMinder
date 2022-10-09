//
//  SwordMinderApp.swift
//  SwordMinder
//
//  Created by John Delano on 6/17/22.
//

import SwiftUI

@main
struct SwordMinderApp: App {
    let bible = Bible(translation: .kjv, url: Bundle.main.url(forResource: "kjv", withExtension: "json")!)
    var body: some Scene {
        WindowGroup {
            SwordMinderView(swordMinder: SwordMinder())
        }
    }
}
