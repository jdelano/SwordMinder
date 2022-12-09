//
//  CustomSetView.swift
//  TheSpokenWord
//
//  Created by Logan Davis on 11/1/22.
//
// Borrowed the design code from a todo app
// https://github.com/Archetapp/ToDoAppExample
// I did not have this in the original requirements and it may not be needed per the swordmidner original code. But I saw it onlien and thought it could potentially be useful. 

import Foundation

import SwiftUI

struct CustomSetView: View {
    
    @State var newVerse : String = ""
    
    var searchBar : some View {
        HStack {
            TextField("Enter in a new verse", text: self.$newVerse)
            Button(action: self.addNewVerse, label: {
                Text("Add New")
            })
        }
    }
    
    func addNewVerse() {
        self.newVerse = ""
        //Add auto generated id in the future.
    }
    
    var body: some View {
        NavigationView {
            VStack {
                searchBar.padding()
                List {
                }.navigationBarTitle("Verses")
                .navigationBarItems(trailing: EditButton())
            }
        }
    }
}

struct CustomSetView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSetView()
    }
}
