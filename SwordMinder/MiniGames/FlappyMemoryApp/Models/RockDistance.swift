//
//  RockDistance.swift
//  SwordMinder
//
//  Created by Michael Smithers on 12/14/22.
//

import Foundation

enum RockDistance : CaseIterable {
    case spread
    case medium
    case close
    
    var distance: CGFloat {
        switch self {
        case .spread : return 70
        case .medium : return 60
        case .close : return 50
        }
    }
}
