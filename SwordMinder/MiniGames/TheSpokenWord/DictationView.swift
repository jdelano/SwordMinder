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
    
    @State var textFieldText: String = ""
    
    var body: some View {
        VStack {
            ZStack (alignment: .top) {
                VStack {
                    Text(reference.toString()) //will be one of the objects in the array of verses
                        .font(.largeTitle)
                        .padding(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(lineWidth: 3)
                        )
                        Spacer()
                    Text("Type or dictate the reference below:")
                }
            }
            ZStack{
                TextField("Type something here...", text: $textFieldText, axis: .vertical)
                    .lineLimit(8...)
                    .padding()
                    .background(Color.gray.opacity(0.3).cornerRadius(10))
                    .foregroundColor(.red)
                    .font(.headline)
            }.padding()
            VStack {
                Spacer()
                
                ScoreSet(setTitle: "Submit", buttonColor: "#587099"){
                    ScoreView(reference: reference, answer: textFieldText)
                }
            }
        }
    }
}

struct ScoreSet<Destination : View>: View {
    var setTitle: String
    var buttonColor: String
    var destination: Destination
    
    init(setTitle: String, buttonColor: String, @ViewBuilder destination: () -> Destination) {
        self.setTitle = setTitle
        self.buttonColor = buttonColor
        self.destination = destination()
    }
    
    var body: some View{
        NavigationLink {
            destination
        } label: {
            Text(setTitle)
                .frame(height:55)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(Color(buttonColor))
        .padding(10)
    }
}

struct DictationView_Previews: PreviewProvider {
    static var previews: some View {
        DictationView(reference: Reference(book: Book(named: "John")!, chapter: 3, verse: 16)).preferredColorScheme(.light)
//        DictationView().preferredColorScheme(.dark)
    }
}
