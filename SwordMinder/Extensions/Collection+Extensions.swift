//
//  Collection+Extensions.swift
//  SwordMinder
//
//  Created by John Delano on 12/1/22.
//

import Foundation

extension Collection where Element: Identifiable {
    func index(matching element: Element) -> Self.Index? {
        firstIndex(where: { $0.id == element.id })
    }
}
