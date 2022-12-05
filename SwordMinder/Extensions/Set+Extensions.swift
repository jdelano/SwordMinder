//
//  Set+Extensions.swift
//  SwordMinder
//
//  Created by John Delano on 12/5/22.
//

import Foundation

extension Set {
    mutating func toggleMembership(for element: Element) {
        if self.contains(element) {
            self.remove(element)
        } else {
            self.insert(element)
        }
    }
}
