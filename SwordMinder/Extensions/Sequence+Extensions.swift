//
//  Sequence+Extensions.swift
//  SwordMinder
//
//  Created by John Delano on 12/5/22.
//

import Foundation

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
