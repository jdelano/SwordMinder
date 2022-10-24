//
//  Date+Extensions.swift
//  SwordMinder
//
//  Created by John Delano on 10/9/22.
//

import Foundation

extension Date {
    var hour: Int? {
        Calendar.current.dateComponents([.hour], from: self).hour
    }
    
    var minute: Int? {
        Calendar.current.dateComponents([.minute], from: self).minute
    }
    
    func hours(since date: Date) -> Int? {
        Calendar.current.dateComponents([.hour], from: date, to: self).hour
    }
}
