//
//  JustMemorizeView.swift
//  SwordMinder
//
//  Created by Jared Waltz on 12/11/22.
//

/*import SwiftUI

struct JustMemorizeView: View {
    /// may have to use an optional here in the case that state does not default to main menu.
    //let defaultJMView: JMView = .mainMenu
    @State var currentJMView: JMView
    
    enum JMView {
        case instructions
        case settings
        case mainMenu
        case versePreview
        case quizView
        case results
    }
    
    var body: some View {
        switch currentJMView {
            case .instructions:
                JM_Instructions()
            case .settings:
                JM_Settings()
            case .mainMenu:
                JM_MainMenu(currentApp: .constant(.justMemorizeApp))
            case .versePreview:
                JM_VersePreview(verseReference: Reference())
            case .quizView:
                JM_QuizView()
            case .results:
                JM_Results()
        }
    }
    
    init(currentJMView: JMView) {
        self.currentJMView = currentJMView
    }
}

struct JustMemorizeView_Previews: PreviewProvider {
    static var previews: some View {
        JustMemorizeView(currentJMView: .mainMenu)
    }
}*/
