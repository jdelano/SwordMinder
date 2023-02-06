//
//  CGPoint+Extensions.swift
//  SwordMinder
//
//  Created by John Delano on 2/1/23.
//

import Foundation

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return (self.x - point.x) * (self.x - point.x) + (self.y - point.y) * (self.y - point.y)
    }
}
