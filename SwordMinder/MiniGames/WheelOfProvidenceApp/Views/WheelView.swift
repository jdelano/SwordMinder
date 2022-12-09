//
//  WheelView.swift
//  SwordMinder
//
//  Created by user226647 on 12/9/22.
//

import SwiftUI


struct WheelView: View {
    let easySlice1 = PieSliceData(startAngle: Angle(degrees: -45), endAngle: Angle(degrees: 45), text: "Easy", color: Color.green)
            let mediumSlice = PieSliceData(startAngle: Angle(degrees:45), endAngle: Angle(degrees: 135), text: "Medium", color: Color.yellow)
            let easySlice2 = PieSliceData(startAngle: Angle(degrees:135), endAngle: Angle(degrees:225), text: "Easy", color: Color.green)
            let hardSlice = PieSliceData(startAngle: Angle(degrees:225), endAngle: Angle(degrees:315), text: "Hard", color: Color.red)
    var body: some View {
        GeometryReader { geometry in
            PieSliceView(pieSliceData: easySlice1)
            PieSliceView(pieSliceData: mediumSlice)
            PieSliceView(pieSliceData: easySlice2)
            PieSliceView(pieSliceData: hardSlice)
        }
    }
}

struct WheelView_Previews: PreviewProvider {
    static var previews: some View {
        WheelView()
    }
}
