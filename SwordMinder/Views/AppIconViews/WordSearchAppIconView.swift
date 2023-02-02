//
//  WordSearchAppIconView.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import SwiftUI

struct WordSearchAppIconView: View {
    var action: () -> Void
    var body: some View {
        Button {
            action()
        } label: {
            Image("WordFindIcon")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
        }
    }
}

struct WordSearchAppIconView_Previews: PreviewProvider {
    static var previews: some View {
        WordSearchAppIconView(action: { })
    }
}
