//
//  TutorialView.swift
//  SwordMinder
//
//  Created by John Delano on 2/7/23.
//

import SwiftUI

struct TutorialView: View {
    @Binding var showTutorial: Bool
    @State private var currentPage = 0
    
    let images = ["WordFindTutorialGrid1", "WordFindTutorialGrid2"]
    
    var body: some View {
        ZStack {
            TabView {
                VStack {
                    Spacer()
                    Image("WordFindTutorial1")
                        .resizable()
                        .scaledToFit()
                    Text("Select a passage to show the word grid.")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                }
                .padding(.bottom, 50)
                VStack {
                    Spacer()
                    Image("WordFindTutorial2")
                        .resizable()
                        .scaledToFit()
                    Text("Drag your finger across the letters in the grid to highlight each of the words in the Words to Find list. Find all the words to win! Gems are awarded based on difficulty and only if you find all the words before the timer runs out!")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                    SMButtonView(caption: "Start Playing", glyph: {}) {
                        self.showTutorial = false
                    }
                    .padding()
                }
                .padding(.bottom, 60)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .padding(.top, 50)
            closeButton
        }
        .background(Color.black.cornerRadius(10))
        .edgesIgnoringSafeArea(.all)
    }
    var closeButton: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showTutorial = false
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray)
                            .shadow(color: .gray, radius: 3.0, x: 2.0, y: 2.0)
                            .frame(width: 35)
                        Text("X")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    }
                }.padding()
                Spacer()
            }
            Spacer()
        }
    }
}



struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        Color.blue.overlay(
            TutorialView(showTutorial: .constant(true))
        )
    }
}
