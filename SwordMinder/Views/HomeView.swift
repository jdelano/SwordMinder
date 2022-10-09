//
//  HomeView.swift
//  SwordMinder
//
//  Created by John Delano on 7/10/22.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geometry in
//            let rect = geometry.frame(in: .local)
            VStack {
                HStack(alignment: .top) {
                    GeometryReader { knightGeometry in
                        let rect = knightGeometry.frame(in: .local)
                        ZStack(alignment: .top) {
                            Image("knightBody")
                                .resizable()
                                .frame(width:rect.width, height: rect.height * 0.88)
                                .aspectRatio(contentMode: .fit)
                            Image("damascusHelmet")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .position(x: rect.midX - 3, y:40)
                            Image("damascusChestplate")
                                .resizable()
                                .frame(width: rect.width, height: 190)
                                .position(x: rect.midX + 4, y:145)
                            Image("damascusBelt")
                                .resizable()
                                .scaledToFit()
                                .position(x:rect.midX + 3, y:278)
                            Image("damascusShoes")
                                .resizable()
                                .scaledToFit()
                                .position(x:rect.midX + 3, y:388)
                            
                        }
                        .padding()
                    }
                    VStack(alignment: .leading) {
                        Text("Gems: 0")
                            .font(.title)
                        ButtonView(glyph: "arrow.up", caption: "Upgrade Helmet") {
                            
                        }
                        ButtonView(glyph: "arrow.up", caption: "Upgrade Chest") {
                            
                        }
                        ButtonView(glyph: "arrow.up", caption: "Upgrade Belt") {
                            
                        }
                        ButtonView(glyph: "arrow.up", caption: "Upgrade Shoes") {
                            print()
                        }
                    }
                    .padding()
                }
                .frame(height: geometry.size.height * 2/3)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

