//
//  VerseTappingView.swift
//  SwordMinder
//
//  Created by Caleb Kowalewski on 12/12/22.


import SwiftUI

struct VerseTappingView: View {// State variables to track the rectangle's offset
    @State private var offsetY = 125
    // State variable to track the rectangle's x-position
    @State private var rectangleX = 200
    @Namespace var boxdrop
    @State private var dropped: Bool = false
    
    @State var verseReference: Reference
    @EnvironmentObject var swordMinder: SwordMinder
    
   // @ObservedObject ViewModels
   
    var body: some View {
        // Use a GeometryReader to get the size of the screen
        GeometryReader { geometry in
            // Use a VStack to contain the rectangle
            VStack {
                Group {
                    // Call the rectangle view
                    if !dropped {
                        movingrectangle
                            .matchedGeometryEffect(id: 1, in: boxdrop)
                            .position(x: CGFloat(rectangleX), y: CGFloat(offsetY))
                    }
                }
                Spacer()
                Group {
                    if dropped {
                        movingrectangle
                            .matchedGeometryEffect(id: 1, in: boxdrop)
                            .position()
                    }
                }
                
             //let words = swordMinder.bible.words(for:verseReference)
          let words = ["In", "the", "beginning", "God", "created","the","heavens","and"]
                
                let columns = [GridItem(.adaptive(minimum:90))]
                LazyVGrid(columns: columns, spacing: 1)
                 {
                    ForEach(words, id: \.self) { word in
                        Rectangle()
                            .frame(width: 100, height: 50)
                            .foregroundColor(.white)
//                            .overlay(
//                                Text(word)
//                                    .font(.title)
//                                    .foregroundColor(.gray)
//                            )
//
                            
                        .border(.black, width: 4)
                    }
                     
                 }.onTapGesture {
                    rectangleX = Int(randomX(for: geometry.size))
                     withAnimation(Animation.linear(duration: 4.0)) {
                    //bottom limit for rectangle / where it stops
                         self.offsetY = 700
                     }
                     // second rectabgle
                     DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                         withAnimation(.linear(duration: 5)) {
                                 dropped = true
                            }
                        }
                 }
            }
        }
    }
    // Need to add code that if the words are a match, the border is turned green, if not a match then border goes red, the user can then touch the next block they think is the right order, until they find the correct spot for the block
    
    // function to generate a random x-position for the rectangle
    private func randomX(for size: CGSize) -> CGFloat {
        CGFloat.random(in: 0..<size.width-50)
    }
    
    // Need to work on haveing the word in the box, be populated by each word of the string from the verse, after this one block will fall with a random word from the string, I will use the length of the string to determine how many blocks/rectangles need to fall
    
    // View that represents the rectangle
    private var movingrectangle: some View {
     
            Rectangle()
           
           
            // Set the rectangle's size
                .frame(width: 75, height: 50)
                .foregroundColor(.white)
                .border(.black, width: 4)
                .overlay(Text("In"))
                .font(.title)
                .foregroundColor(.gray)
      
        
    }
}

struct VerseTappingView_Previews: PreviewProvider {
    static var previews: some View {
        VerseTappingView(verseReference: Reference())
            .environmentObject(SwordMinder())
    }
}

