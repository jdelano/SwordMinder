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
                    VerseSet(setTitle: "John", buttonColor: "#3F5576") { () -> DictationView in
                        let book = swordMinder.bible.book(matching: "John")!
                        let numChapters = swordMinder.bible.chapters(in: book).count
                        let chapter = Int.random(in: 1...numChapters)
                        let numVerses = swordMinder.bible.verses(in: book, chapter: chapter).count
                        let verse = Int.random(in: 1...numVerses)
                        let reference = Reference(book: book, chapter: chapter, verse: verse)
                        return DictationView(reference: reference)
                        
                        //For seasonal aspects, these verse sets will change based upon the seaon and different topics.
                        //                    VerseSet(setTitle: "Romans", buttonColor: "#3F5576") {
                        //
                        //                    }
                        //                    VerseSet(setTitle: "Psalms", buttonColor: "#3F5576") {
                        //
                        //                    }
                        //                    Spacer()
                        ////                    NavigationLink(destination: DictationView()) {
                        ////                        VerseSet(setTitle: "Random", buttonColor: "#2F3148")
                        ////                                    }
                        ////                    VerseSet(setTitle: "Random", buttonColor: "#2F3148")
                        //
                        //                    VerseSet(setTitle: "Random", buttonColor: "#2F3148") {
                        //
                        //                    }
                        //                    VerseSet(setTitle: "Custom Verse Set", buttonColor:"#101116")  {
                        //
                        
                    }//this will be called via the user's verse set in swordminder itself
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
            }
            .navigationBarItems(
                leading: Button {
                    currentApp = .swordMinder
                } label:{ Image(systemName: "chevron.backward")}.accentColor(Color(UIColor(named: "BackButton")!)))
            
            //trailing: Button("Settings",action: { }).accentColor(.red))
        }
    }
    
    //    private func addItem() {
    //        withAnimation {
    //            addPassage = Passage()
    //            editorConfig.present()
    //        }
    //    }
    
}

struct VerseSet<Destination : View>: View {
    var setTitle: String
    var buttonColor: String
    var destination: () -> Destination
    
    var body: some View{
        NavigationLink {
            destination()
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

struct RandomSet: View {
    var setTitle: String
    var buttonColor: String
    
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var passage: Passage
    @State var currentVerse: String
    
    
    var body: some View{
        Button {
            currentVerse = passage.referenceFormatted
//            ForEach(swordMinder.passages) { passage in
//            }
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
