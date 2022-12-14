//
//  ContentView.swift
//  TheSpokenWord
//
//  Created by Logan Davis on 11/1/22.
//
// Only thing that should change is a back button and I may modify the button colors, but I thought the button colors were fine for now.
// I assumed we would get to learning more about the navigation bar later and was more a functionality thing than a design choice.

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var currentApp: Apps
    @State private var editorConfig = EditorConfig()
    @State private var addPassage: Passage = Passage()
    @Binding var passage: Passage
    
    var body: some View {
        NavigationStack {
            VStack{
                ZStack (alignment: .top) {
                    
                    Text("Select a Verse Set:")
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
                VStack {
                    VerseSet(setTitle:"John", buttonColor: "#3F5576") {
                        if let reference = swordMinder.bible.randomReference(matching: "John") {
                            DictationView(reference: reference)
                        }
                    }
                    VerseSet(setTitle:"Luke", buttonColor: "#3F5576") {
                        if let reference = swordMinder.bible.randomReference(matching: "Luke") {
                            DictationView(reference: reference)
                        }
                    }
                    VerseSet(setTitle:"Romans", buttonColor: "#3F5576") {
                        if let reference = swordMinder.bible.randomReference(matching: "Romans") {
                            DictationView(reference: reference)
                        }
                    }
                }
                Spacer()
                VStack {
                    Spacer()
                    VerseSet(setTitle:"Custom Set", buttonColor: "#101116") {
                        if let reference = swordMinder.bible.randomReference(matching: "") {
                            DictationView(reference: reference)
                        } //I know this is not currently working. I couldnt figure out how to get it.
                    }
                    Spacer()
                    VStack {
                        VerseSet(setTitle:"Random", buttonColor: "#2F3148") {
                            if let reference = swordMinder.bible.randomReference(matching: Book.names.randomElement()!) {
                                DictationView(reference: reference)
                            }
                        }
                    }
                    Spacer()
                    
                }
                Spacer()
                HStack{
                    Text("Today's daily challenge:")
                        .font(.title2)
                    Text("3 Points")
                        .font(.title2)
                        .foregroundColor(.red)
                        .bold()
                }
                // these challenges will change daily and will add points to the user's overall score if completed. Point values will also change
                ZStack{
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 3)
                        .frame(width:350, height: 50)
                    Text("Get 3 verses over 90% 3 times in a row!")
                }
                .navigationBarItems(
                    leading: Button {
                        currentApp = .swordMinder
                    } label:{ Image(systemName: "chevron.backward")}.accentColor(Color(UIColor(named: "BackButton")!)))
            }
        }
    }
    
    struct VerseSet<Destination : View>: View {
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
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            //        ContentView().preferredColorScheme(.light)
            //        ContentView().preferredColorScheme(.dark)
            ContentView(currentApp: .constant(.spokenWordApp), passage: .constant(Passage(from: Reference(book: Book(named: "Psalms")!, chapter: 119, verse: 100))))
                .environmentObject(SwordMinder()).preferredColorScheme(.dark)
        }
    }
}
