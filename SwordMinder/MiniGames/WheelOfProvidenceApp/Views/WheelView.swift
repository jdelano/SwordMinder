//
//  WheelView.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import SwiftUI


struct WheelView: View {
    
    var easySlice1: PieSliceData{PieSliceData(startAngle: Angle(degrees: -45), endAngle: Angle(degrees: 45), text: "1 Gem", color: Color.green)}
    var mediumSlice: PieSliceData { PieSliceData(startAngle: Angle(degrees:45), endAngle: Angle(degrees: 135), text: "2 Gems", color: Color.yellow)}
    var easySlice2: PieSliceData {PieSliceData(startAngle: Angle(degrees:135), endAngle: Angle(degrees:225), text: "3 Gems", color: Color.blue)}
    var hardSlice: PieSliceData {PieSliceData(startAngle: Angle(degrees:225), endAngle: Angle(degrees:315), text: "4 Gems", color: Color.red)}
    
    var body: some View {
        GeometryReader { geometry in
            PieSliceView(pieSliceData: easySlice1)
            PieSliceView(pieSliceData: mediumSlice)
            PieSliceView(pieSliceData: easySlice2)
            PieSliceView(pieSliceData: hardSlice)
        }
    }
}
