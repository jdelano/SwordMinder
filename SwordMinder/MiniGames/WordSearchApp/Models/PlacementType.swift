//
//  PlacementType.swift
//  SwordMinder
//
//  Created by John Delano on 12/3/22.
//

import Foundation

enum PlacementType : CaseIterable {
    case leftRight
    case rightLeft
    case upDown
    case downUp
    case topLeftBottomRight
    case topRightBottomLeft
    case bottomLeftTopRight
    case bottomRightTopLeft
    
    var movement: (x: Int, y: Int) {
        switch self {
            case .leftRight : return (1, 0)
            case .rightLeft : return (-1, 0)
            case .upDown : return (0, 1)
            case .downUp : return (0, -1)
            case .topLeftBottomRight : return (1, 1)
            case .topRightBottomLeft : return (-1, 1)
            case .bottomLeftTopRight : return (1, -1)
            case .bottomRightTopLeft : return (-1, -1)
        }
    }
}
