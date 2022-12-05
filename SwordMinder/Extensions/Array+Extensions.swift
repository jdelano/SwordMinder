//
//  Array+Extensions.swift
//  SwordMinder
//
//  Created by John Delano on 12/5/22.
//

import Foundation

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    func removingDuplicates<ElementProperty : Hashable>(for property: (Element) -> ElementProperty) -> [Element] {
        var addedDict = [ElementProperty: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: property($0)) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
    
    mutating func removeDuplicates<ElementProperty : Hashable>(for property: (Element) -> ElementProperty) {
        self = self.removingDuplicates(for: property)
    }

}
