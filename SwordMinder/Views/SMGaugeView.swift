//
//  SMGaugeView.swift
//  SwordMinder
//
//  Created by John Delano on 10/20/22.
//

import SwiftUI

struct SMGaugeView: View {
    var current: Double
    var minimum: Double
    var maximum: Double
    var imageName: String
    
    var body: some View {
        Gauge(value: current, in: minimum...maximum) {
            Image(systemName: imageName)
                .foregroundColor(.accentColor3)
            
        } currentValueLabel: {
            Text("\(current, specifier: "%.0f")")
                .foregroundColor(.black)
        }
        .gaugeStyle(.accessoryCircular)
        .tint(Gradient(colors: [.accentColor, .accentColor3]))
    }
}
 
struct SMGauge_Previews: PreviewProvider {
    static var previews: some View {
        SMGaugeView(current: 32, minimum: 1, maximum: 40, imageName: "head.fill")
    }
}
