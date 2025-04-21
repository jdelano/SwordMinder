//
//  TutorialView.swift
//  SwordMinder
//
//  Created by John Delano on 2/7/23.
//

import SwiftUI

struct TutorialView: View {
    @Binding var showTutorial: Bool
    
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
                .padding(.bottom, DrawingConstants.pageVerticalPadding)
                VStack {
                    Spacer()
                    Image("WordFindTutorial2")
                        .resizable()
                        .scaledToFit()
                    Text("Drag your finger across the letters in the grid to highlight each of the words in the Words to Find list. Find all the words to win! Gems are awarded based on difficulty and only if you find all the words before the timer runs out!")
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .padding()
                    SMButtonView(title: "Start Playing") {
                        self.showTutorial = false
                    }
                    .padding()
                }
                .padding(.bottom, DrawingConstants.pageVerticalPadding)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
            .padding(.top, DrawingConstants.pageVerticalPadding)
            closeButton
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    private var closeButton: some View {
        VStack {
            HStack {
                Button(action: {
                    self.showTutorial = false
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray)
                            .shadow(color: .gray, radius: DrawingConstants.closeButtonShadowRadius, x: DrawingConstants.closeButtonShadowOffset.width, y: DrawingConstants.closeButtonShadowOffset.height)
                            .frame(width: DrawingConstants.closeButtonSize.width, height: DrawingConstants.closeButtonSize.height)
                        Text("X")
                            .foregroundColor(.white)
                            .font(.system(size: DrawingConstants.closeButtonFontSize, weight: .bold))
                    }
                }.padding()
                Spacer()
            }
            Spacer()
        }
    }
    
    private struct DrawingConstants {
        static let pageVerticalPadding: CGFloat = 50.0
        static let closeButtonShadowRadius: CGFloat = 3.0
        static let closeButtonShadowOffset = CGSize(width: 2.0, height: 2.0)
        static let closeButtonSize = CGSize(width: 35, height: 35)
        static let closeButtonFontSize: CGFloat = 20.0
    }
}



struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        Color.blue.overlay(
            TutorialView(showTutorial: .constant(true))
        )
    }
}
