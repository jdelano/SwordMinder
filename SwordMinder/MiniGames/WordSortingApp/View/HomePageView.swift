//
//  HomePageView.swift
//  SwordMinder
//
//  Created by Caleb Kowalewski on 12/12/22.
//


import SwiftUI
// @State var versereference: Reference
// @environmentObject var swordMinder: SwordMinder
struct HomegameView: View {
   
    let name: String

    var body: some View {
            if name == "Bible Verse"{
                HStack{
                    Text("\(name):")
                        .font(.largeTitle)
                    verseReferences.font(.title2).padding()
                }
                VStack{
                    verse
                    }
            }
            if name == "Game Rules"{
                Text("\(name):")
                    .font(.largeTitle)
                rules
            }
    }
}

struct HomePageView: View {
    @ObservedObject var wordSorting: WordSorting
    @EnvironmentObject var swordMinder: SwordMinder
    @Binding var currentApp: Apps
    let event = ["Game Rules","Bible Verse"]

    var body: some View {
        NavigationView {
            VStack{
                Text("Welcome to the game!!!").font(.title)
                
                List(event, id: \.self) { event in
                    NavigationLink(destination: HomegameView(name: event)) {
                        Text(event)
                    }
                }
                .padding()
                    .navigationTitle("Word Sorting App:")
                HStack{
                    NavigationLink(destination: gameView(passage: Passage(), verseReference: Reference())){
                        Text("Tap to begin game").foregroundColor(.black)
                            .padding()
                            .background(Color.gray)
                            .cornerRadius(80)
                    }.padding()
                                Button {
                                //  currentApp = .swordMinder
                                } label: {
                                    Text("Return to Sword Minder").foregroundColor(.black)
                                        .padding()
                                }
                                .background(Color.gray)
                                .cornerRadius(80)
                }
            }
        }
    }
}

private var rules: some View{
    Text("The user should tap the blank rectangle placeholder for the position where the free falling word should go in the verse. If you choose the wrong place, you will loose points")
}
public var verseReferences: some View{
    Text("Genesis 1:1").font(.title2)
}
private var verse: some View{
    Text("'In the beginning God created the heavens and the earth.'")
}


struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(wordSorting: WordSorting(), currentApp: .constant(.wordSortingApp))
            .environmentObject(SwordMinder())
        //currentApp: .constant(.wordSortingApp)).environmentObject(SwordMinder()
    }
}

