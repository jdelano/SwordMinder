//
//  DragState.swift
//  SwordMinder
//
//  Created by John Delano on 2/1/23.
//

import Foundation

enum DragState {
    case inactive
    case dragging(start: CGPoint, current: CGPoint)
    
    var isDragging: Bool {
        switch self {
            case .inactive: return false
            case .dragging: return true
        }
    }
    
    var startPoint: CGPoint {
        switch self {
            case .inactive: return .zero
            case .dragging(let start, _): return start
        }
    }
    
    var endPoint: CGPoint {
        switch self {
            case .inactive: return .zero
            case .dragging(_, let end): return end
        }
    }
}
