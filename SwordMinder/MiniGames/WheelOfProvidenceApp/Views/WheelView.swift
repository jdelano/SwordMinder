//
//  WheelView.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import SwiftUI


struct WheelView: View {
    var verse1: String
    var verse2: String
    var verse3: String
    var verse4: String
    
    var easySlice1: PieSliceData{PieSliceData(startAngle: Angle(degrees: -45), endAngle: Angle(degrees: 45), text: verse1, color: Color.green)}
    var mediumSlice: PieSliceData { PieSliceData(startAngle: Angle(degrees:45), endAngle: Angle(degrees: 135), text: verse2, color: Color.yellow)}
    var easySlice2: PieSliceData {PieSliceData(startAngle: Angle(degrees:135), endAngle: Angle(degrees:225), text: verse3, color: Color.blue)}
    var hardSlice: PieSliceData {PieSliceData(startAngle: Angle(degrees:225), endAngle: Angle(degrees:315), text: verse4, color: Color.red)}
    
    var body: some View {
        GeometryReader { geometry in
            PieSliceView(pieSliceData: easySlice1)
            PieSliceView(pieSliceData: mediumSlice)
            PieSliceView(pieSliceData: easySlice2)
            PieSliceView(pieSliceData: hardSlice)
        }
    }
}
