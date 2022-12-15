//
//  JM_PassageView.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/14/22.
//

import SwiftUI

///This code acts little more than an in-app reference for SwordMinder's MemorizeView.
import SwiftUI

struct JM_PassageView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var currentView: JustMemorizeView.viewState
    
    var body: some View {
        VStack {
            HStack {
                Button("Back to Just Memorize") {
                    withAnimation {
                        currentView = .settings
                    }
                }
            }
                NavigationView {
                    List {
                        ForEach(swordMinder.passages) { passage in
                            NavigationLink {
                                JM_VerseView(passage: passage)
                            } label: {
                                HStack {
                                    Text(.init(passage.referenceFormatted))
                                    Spacer()
                                }
                            }
                        }
                    }
                    .navigationTitle("My Passages")
                    //.foregroundColor(Color("JMDarkGold"))
            }
        }
        //.frame(width: 400, height: 800)
        //.background(Color("JMBlack"))
    }
}

struct JM_VerseView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    var passage: Passage
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text(.init(passage.referenceFormatted))
                //.foregroundColor(Color("JMLightGold"))
            ScrollView {
                Text(.init(swordMinder.bible.text(for: passage)))
                    //.foregroundColor(Color("JMLightGold"))
            }
        }
        //.background(Color("JMBlack"))
    }
}

struct JM_PassageView_Previews: PreviewProvider {
    static var previews: some View {
        let swordMinder = SwordMinder(player: Player(passages: [Passage()]))
        return JM_PassageView(currentView: .constant(.passageView))
            .environmentObject(swordMinder)
    }
}
