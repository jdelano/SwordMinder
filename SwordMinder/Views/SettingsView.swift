//
//  SettingsView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var swordMinder: SwordMinder
    
    var body: some View {

        NavigationStack {
            Form {
                Section("Credits") {
                    app(name: "SwordMinder", author: "John D. Delano, Ph.D.")
                    app(name: "Word Search", author: "John D. Delano, Ph.D.")
                    
                }
            }
        }
    }
    
    func app(name: String, author: String) -> some View {
        HStack {
            Text(name)
            Spacer()
            Text(author)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SwordMinder())
    }
}
