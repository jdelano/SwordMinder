//
//  ArmorUpgradeView.swift
//  SwordMinder
//
//  Created by John Delano on 10/20/22.
//

import SwiftUI
 
struct ArmorUpgradeView: View {
    @Environment(\.verticalSizeClass) var sizeClass
    private var isLandscape: Bool {
        sizeClass == .compact
    }

    var currentLevel: Int
    var upgradeCost: Int
    var imageName: String
    var enabled = true
    var action: () -> Void
    
    var body: some View {
        let layout = isLandscape ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
        layout {
            SMGaugeView(current: Double(currentLevel), minimum: 1, maximum: 40, imageName: imageName)
                .padding(.horizontal)
            SMButtonView(caption: "Level Up") {
                GemView(amount: upgradeCost)
                    .frame(width: DrawingConstants.gemWidth, height: DrawingConstants.gemHeight)
            } action: {
                action()
            }
            .frame(width: DrawingConstants.buttonWidth)
            .disabled(!enabled)
        }
        .padding(.bottom)
    }
    
    private struct DrawingConstants {
        static let gemWidth: CGFloat = 25
        static let gemHeight: CGFloat = 25
        static let buttonWidth: CGFloat = 125
    }
}

struct ArmorUpgradeView_Previews: PreviewProvider {
    static var previews: some View {
        ArmorUpgradeView(currentLevel: 32, upgradeCost: 99, imageName: "brain.head.fill", enabled: false, action: { })
        ArmorUpgradeView(currentLevel: 32, upgradeCost: 99, imageName: "brain.head.fill", enabled: true, action: { })
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
