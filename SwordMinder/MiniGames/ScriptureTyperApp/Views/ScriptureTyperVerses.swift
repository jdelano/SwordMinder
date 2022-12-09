//
//  ScriptureTyperVerses.swift
//  SwordMinder
//
//  Created by Jacob Baird on 12/7/22.
//
//
import SwiftUI

struct ScriptureTyperVerses: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @State private var editorConfig = EditorConfig()
    @State private var addPassage: Passage = Passage()
    @Binding var currentApp: Apps
    var body: some View {
        NavigationStack {
            Button {
                withAnimation {
                    currentApp = .swordMinder
                }
            } label:{
                Image(systemName: "house")
            }
            List {
                ForEach(swordMinder.passages) { passage in
                    NavigationLink {
                        FlashCardView(passage: passage)
                    } label: {
                        HStack {
                            Text(.init(passage.referenceFormatted))
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("My Passages")
        }
        .overlay(!swordMinder.isLoaded ? ProgressView() : nil)
        .sheet(isPresented: $editorConfig.isPresented, onDismiss: {
            if editorConfig.needsSaving {
                swordMinder.addPassage(addPassage)
            }
        }) {
            PassagePickerView(editorConfig: $editorConfig, passage: $addPassage)
        }
    }
}
struct ScriptureTyperVerses_Previews: PreviewProvider {
    static var previews: some View {
        ScriptureTyperVerses(currentApp: .constant(.scriptureTyperApp))
            .environmentObject(SwordMinder())
    }
}
