//
//  VerseView2.swift
//  TheSpokenWord
//
//  Created by Logan Davis on 11/1/22.
//

import SwiftUI

struct DictationView: View {
    
    @State private var width: CGFloat = 0
    @State private var height: CGFloat = 0
    var reference: Reference
    
    var body: some View {
        VStack {
            ZStack (alignment: .top) {
                VStack {
                    Text("Verse Set 1:")//will call the set that was selected and to which is being pulled from
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()

                    Text(reference.toString()) //will be one of the objects in the array of verses
                        .font(.largeTitle)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                        )
                        Spacer()
                }
            }
            Spacer()
            Spacer()
            ZStack{
                RoundedRectangle (cornerRadius: 15).stroke(.gray, lineWidth: 5)
                    .frame(width: 375, height:500)
                Text("Dictated text will show up here")
                //
                //the user will be able to edit this text as well, very similar to a text dictation on imessage, in fact I'd like it to be almost identical to this. 
            }
//            Spacer()
            VStack {
//                Spacer()
//                GeometryReader { geometry in
//                    Button {
//                    } label: {
//                        Image(systemName:"mic")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
//                    }
//                }
                Spacer()
                Button {
                } label: {
                    Text("Submit")
                        .frame(height:55)
                        .frame(maxWidth: .infinity)
                }
                
                .buttonStyle(.borderedProminent)
                .tint(Color("#587099"))
                .padding(10)
            }
        }
    }
}

struct DictationView_Previews: PreviewProvider {
    static var previews: some View {
        DictationView(reference: Reference(book: Book(named: "John")!, chapter: 3, verse: 16)).preferredColorScheme(.light)
//        DictationView().preferredColorScheme(.dark)
    }
}
