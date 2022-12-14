//
//  WheelView.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import SwiftUI


struct WheelView: View {
    var pieWheel: PieWheel
    
    var easySlice1: PieSliceData{PieSliceData(startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), text: pieWheel.text1, color: Color.green)}
    var mediumSlice: PieSliceData { PieSliceData(startAngle: Angle(degrees:90), endAngle: Angle(degrees: 180), text: pieWheel.text2, color: Color.yellow)}
    var easySlice2: PieSliceData {PieSliceData(startAngle: Angle(degrees:180), endAngle: Angle(degrees:270), text: pieWheel.text3, color: Color.blue)}
    var hardSlice: PieSliceData {PieSliceData(startAngle: Angle(degrees:270), endAngle: Angle(degrees:360), text: pieWheel.text4, color: Color.red)}
    
    var body: some View {
        GeometryReader { geometry in
            PieSliceView(pieSliceData: easySlice1)
            PieSliceView(pieSliceData: mediumSlice)
            PieSliceView(pieSliceData: easySlice2)
            PieSliceView(pieSliceData: hardSlice)
        }
    }
}
